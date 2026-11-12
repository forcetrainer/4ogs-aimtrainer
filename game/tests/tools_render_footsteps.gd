extends SceneTree
## Offline tool: makes the directional footstep sounds. Each footstep is
## passed through a dummy-head impulse response for every stored direction,
## which bakes in the timing, level and tone differences between the ears
## that let you hear where a sound is over headphones.
##
## Run: godot --headless --path game --script res://tests/tools_render_footsteps.gd

const Synth = preload("res://scripts/footstep_synth.gd")
const HRIR_DIR := "res://assets/hrtf/sadie_ku100_48k"
const OUT_DIR := "res://assets/audio/footsteps_hrtf"
const TAPS := 256


func _init() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT_DIR))
	var steps := []
	for v in Synth.VARIANTS:
		steps.append(Synth.samples(v))
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
		for v in Synth.VARIANTS:
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
		wav.mix_rate = Synth.MIX_RATE
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
