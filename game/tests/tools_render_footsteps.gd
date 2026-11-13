extends SceneTree
## Offline tool: makes the directional footstep sounds from recordings of
## single steps on a hard surface (Fantozzi's Footsteps, CC0). Each step is
## passed through a dummy-head impulse response for every stored direction,
## which bakes in the timing, level and tone differences between the ears
## that let you hear where a sound is over headphones.
##
## Run: godot --headless --path game --script res://tests/tools_render_footsteps.gd

const SOURCE_DIR := "res://assets/audio/footsteps_src"
const SOURCES := ["StoneL1", "StoneR1", "StoneL2", "StoneR2"]
const RATE := 48000
const SECONDS := 0.28
const HRIR_DIR := "res://assets/hrtf/sadie_ku100_48k"
const OUT_DIR := "res://assets/audio/footsteps_hrtf"
const TAPS := 256


func _init() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT_DIR))
	var steps := []
	for name: String in SOURCES:
		steps.append(_load_step("%s/Fantozzi-%s.ogg" % [SOURCE_DIR, name]))
	var names := []
	for f in DirAccess.get_files_at(HRIR_DIR):
		if f.ends_with(".wav"):
			names.append(f)
	names.sort()
	# First pass: convolve everything and find the loudest sample, so one
	# gain is used for all directions and level differences survive.
	var rendered := {}
	var peak := 0.0
	var started := Time.get_ticks_msec()
	for n: String in names:
		var hrir := _read_hrir("%s/%s" % [HRIR_DIR, n])
		for v in SOURCES.size():
			var lr := [_convolve(steps[v], hrir[0]), _convolve(steps[v], hrir[1])]
			for ch: PackedFloat32Array in lr:
				for x in ch:
					peak = maxf(peak, absf(x))
			rendered["step%d_%s" % [v, n]] = lr
	var gain := 0.9 / peak
	for key: String in rendered:
		var lr: Array = rendered[key]
		var left: PackedFloat32Array = lr[0]
		var right: PackedFloat32Array = lr[1]
		var data := PackedByteArray()
		data.resize(left.size() * 4)
		for i in left.size():
			data.encode_s16(i * 4, int(clampf(left[i] * gain, -1.0, 1.0) * 32767.0))
			data.encode_s16(i * 4 + 2, int(clampf(right[i] * gain, -1.0, 1.0) * 32767.0))
		var wav := AudioStreamWAV.new()
		wav.format = AudioStreamWAV.FORMAT_16_BITS
		wav.mix_rate = RATE
		wav.stereo = true
		wav.data = data
		wav.save_to_wav(ProjectSettings.globalize_path("%s/%s" % [OUT_DIR, key]))
	# Sanity check on the convention: a source at azimuth 90 should be
	# louder in the left ear.
	var side: Array = rendered["step0_azi_90_ele_0.wav"]
	print("azimuth 90: left energy %.3f, right energy %.3f" % [_energy(side[0]), _energy(side[1])])
	print("wrote %d files in %.1f s (gain %.2f)" % [
		rendered.size(), (Time.get_ticks_msec() - started) / 1000.0, gain])
	quit()


func _energy(x: PackedFloat32Array) -> float:
	var s := 0.0
	for v in x:
		s += v * v
	return s


## Left and right impulse responses from a 24-bit stereo WAV with a plain
## 44-byte header.
func _read_hrir(path: String) -> Array:
	var bytes := FileAccess.get_file_as_bytes(path)
	var left := PackedFloat32Array()
	var right := PackedFloat32Array()
	left.resize(TAPS)
	right.resize(TAPS)
	for i in TAPS:
		left[i] = _s24(bytes, 44 + i * 6)
		right[i] = _s24(bytes, 44 + i * 6 + 3)
	return [left, right]


func _s24(bytes: PackedByteArray, at: int) -> float:
	var v := bytes[at] | (bytes[at + 1] << 8) | (bytes[at + 2] << 16)
	if v >= 0x800000:
		v -= 0x1000000
	return v / 8388608.0


func _convolve(x: PackedFloat32Array, h: PackedFloat32Array) -> PackedFloat32Array:
	var out := PackedFloat32Array()
	out.resize(x.size() + h.size() - 1)
	for i in x.size():
		var xi := x[i]
		if xi == 0.0:
			continue
		for j in h.size():
			out[i + j] += xi * h[j]
	return out


## One recorded step as mono samples at 48 kHz: decoded, cut to its start,
## trimmed to SECONDS, faded out, and brought to a standard level.
func _load_step(path: String) -> PackedFloat32Array:
	var stream := AudioStreamOggVorbis.load_from_file(ProjectSettings.globalize_path(path))
	var playback := stream.instantiate_playback()
	playback.start(0.0)
	var from_rate := int(AudioServer.get_mix_rate())
	var frames: PackedVector2Array = playback.mix_audio(1.0, int(stream.get_length() * from_rate))
	var mono := PackedFloat32Array()
	mono.resize(frames.size())
	var peak := 0.0
	for i in frames.size():
		mono[i] = (frames[i].x + frames[i].y) * 0.5
		peak = maxf(peak, absf(mono[i]))
	# Skip any silence before the step lands.
	var start := 0
	while start < mono.size() - 1 and absf(mono[start]) < peak * 0.03:
		start += 1
	start = maxi(start - from_rate / 500, 0)
	var n := mini(int(SECONDS * RATE), int((mono.size() - start) * float(RATE) / from_rate))
	var out := PackedFloat32Array()
	out.resize(n)
	var ratio := float(from_rate) / RATE
	for i in n:
		var pos := start + i * ratio
		var k := int(pos)
		out[i] = lerpf(mono[k], mono[mini(k + 1, mono.size() - 1)], pos - k) / maxf(peak, 1e-9) * 0.8
	var fade_from := int(n * 0.7)
	for i in range(fade_from, n):
		out[i] *= 1.0 - float(i - fade_from) / (n - fade_from)
	return out
