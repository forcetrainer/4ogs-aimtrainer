extends SceneTree
## Offline tool: makes the gunfire sounds from two field recordings of a
## 9 mm submachine gun (Carl Gustav M45, from The Free Firearm Sound
## Library, CC0).
##
## - The close recording is cut into single shots for the player's own gun.
## - The mid-distance recording is cut into single shots for enemy fire, and
##   each is passed through a dummy-head impulse response for every 10
##   degrees around, so over headphones you can hear where it comes from.
##
## Run: godot --headless --path game --script res://tests/tools_make_gunfire.gd

const SOURCE_DIR := "res://assets/audio/gunfire/source"
const OUT_DIR := "res://assets/audio/gunfire"
const HRIR_DIR := "res://assets/hrtf/sadie_ku100_48k"
const RATE := 48000
const TAPS := 256
const PLAYER_SECONDS := 0.75
const ENEMY_SECONDS := 0.35
const TAIL_SECONDS := 1.2
const PLAYER_VARIANTS := 5
const ENEMY_VARIANTS := 2
const AZIMUTH_STEP := 10


func _init() -> void:
	var started := Time.get_ticks_msec()
	var near := _load("%s/G_31P.wav" % SOURCE_DIR)
	var mid := _load("%s/G_20P.wav" % SOURCE_DIR)
	if near.is_empty() or mid.is_empty():
		print("source recordings missing")
		quit(1)
		return

	var near_shots := _onsets(near[0], near[1])
	print("close recording: %.1f s, %d shots found" % [near[0].size() / float(RATE), near_shots.size()])
	for i in mini(PLAYER_VARIANTS, near_shots.size()):
		var left := _slice(near[0], near_shots[i], PLAYER_SECONDS)
		var right := _slice(near[1], near_shots[i], PLAYER_SECONDS)
		var gain := 0.9 / maxf(_peak(left), _peak(right))
		_save("%s/player_%d.wav" % [OUT_DIR, i], left, right, gain)

	var mid_shots := _onsets(mid[0], mid[1])
	print("mid-distance recording: %.1f s, %d shots found" % [
		mid[0].size() / float(RATE), mid_shots.size()])
	# The same shots heard from further off, kept in plain stereo: layered
	# under the player's own shot they give it the report rolling away.
	for v in mid_shots.size():
		var tail_l := _slice(mid[0], mid_shots[v], TAIL_SECONDS)
		var tail_r := _slice(mid[1], mid_shots[v], TAIL_SECONDS)
		_save("%s/tail_%d.wav" % [OUT_DIR, v], tail_l, tail_r,
			0.9 / maxf(_peak(tail_l), _peak(tail_r)))
	var count := 0
	for v in mini(ENEMY_VARIANTS, mid_shots.size()):
		var a := _slice(mid[0], mid_shots[v], ENEMY_SECONDS)
		var b := _slice(mid[1], mid_shots[v], ENEMY_SECONDS)
		var mono := PackedFloat32Array()
		mono.resize(a.size())
		for i in a.size():
			mono[i] = (a[i] + b[i]) * 0.5
		var scale := 0.5 / maxf(_peak(mono), 1e-9)
		for azi in range(0, 360, AZIMUTH_STEP):
			var hrir := _read_hrir("%s/azi_%d_ele_0.wav" % [HRIR_DIR, azi])
			_save("%s/enemy_%d_azi_%d.wav" % [OUT_DIR, v, azi],
				_convolve(mono, hrir[0]), _convolve(mono, hrir[1]), scale)
			count += 1
	print("wrote %d player shots and %d enemy shots in %.1f s" % [
		mini(PLAYER_VARIANTS, near_shots.size()), count, (Time.get_ticks_msec() - started) / 1000.0])
	quit()


## Reads a PCM WAV file and returns [left, right] at 48 kHz, or [] on failure.
func _load(path: String) -> Array:
	var bytes := FileAccess.get_file_as_bytes(path)
	if bytes.size() < 44:
		return []
	var channels := 2
	var rate := 48000
	var bits := 16
	var data_at := -1
	var data_size := 0
	var at := 12
	while at + 8 <= bytes.size():
		var id := bytes.slice(at, at + 4).get_string_from_ascii()
		var size := bytes.decode_u32(at + 4)
		if id == "fmt ":
			channels = bytes.decode_u16(at + 10)
			rate = bytes.decode_u32(at + 12)
			bits = bytes.decode_u16(at + 22)
		elif id == "data":
			data_at = at + 8
			data_size = mini(size, bytes.size() - data_at)
			break
		at += 8 + size + (size & 1)
	if data_at < 0:
		return []
	var step := bits / 8
	var frames := data_size / (step * channels)
	var left := PackedFloat32Array()
	var right := PackedFloat32Array()
	left.resize(frames)
	right.resize(frames)
	for i in frames:
		var p := data_at + i * step * channels
		left[i] = _sample(bytes, p, bits)
		right[i] = _sample(bytes, p + step, bits) if channels > 1 else left[i]
	print("%s: %d Hz, %d bit, %d channels" % [path.get_file(), rate, bits, channels])
	if rate != RATE:
		left = _resample(left, rate)
		right = _resample(right, rate)
	return [left, right]


func _sample(bytes: PackedByteArray, at: int, bits: int) -> float:
	if bits == 24:
		var v := bytes[at] | (bytes[at + 1] << 8) | (bytes[at + 2] << 16)
		if v >= 0x800000:
			v -= 0x1000000
		return v / 8388608.0
	if bits == 32:
		return bytes.decode_s32(at) / 2147483648.0
	return bytes.decode_s16(at) / 32768.0


func _resample(x: PackedFloat32Array, from_rate: int) -> PackedFloat32Array:
	var out := PackedFloat32Array()
	var n := int(x.size() * float(RATE) / from_rate)
	out.resize(n)
	var ratio := float(from_rate) / RATE
	for i in n:
		var pos := i * ratio
		var k := int(pos)
		var next := mini(k + 1, x.size() - 1)
		out[i] = lerpf(x[k], x[next], pos - k)
	return out


## Sample positions where a shot starts: the level jumps above a quarter of
## the loudest moment, at least 0.4 s after the previous shot.
func _onsets(left: PackedFloat32Array, right: PackedFloat32Array) -> Array:
	var threshold := 0.25 * maxf(_peak(left), _peak(right))
	var found := []
	var hold := 0
	for i in left.size():
		if hold > 0:
			hold -= 1
		elif maxf(absf(left[i]), absf(right[i])) >= threshold:
			found.append(maxi(i - RATE / 500, 0))
			hold = int(RATE * 0.4)
	return found


## One shot cut out of a recording, faded out over its last third.
func _slice(x: PackedFloat32Array, start: int, seconds: float) -> PackedFloat32Array:
	var n := mini(int(seconds * RATE), x.size() - start)
	var out := x.slice(start, start + n)
	var fade_from := int(n * 0.66)
	for i in range(fade_from, n):
		out[i] *= 1.0 - float(i - fade_from) / (n - fade_from)
	return out


func _peak(x: PackedFloat32Array) -> float:
	var p := 0.0
	for v in x:
		p = maxf(p, absf(v))
	return p


func _save(path: String, left: PackedFloat32Array, right: PackedFloat32Array, gain: float) -> void:
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
	wav.save_to_wav(ProjectSettings.globalize_path(path))


## Left and right impulse responses from a 24-bit stereo WAV with a plain
## 44-byte header.
func _read_hrir(path: String) -> Array:
	var bytes := FileAccess.get_file_as_bytes(path)
	var left := PackedFloat32Array()
	var right := PackedFloat32Array()
	left.resize(TAPS)
	right.resize(TAPS)
	for i in TAPS:
		left[i] = _sample(bytes, 44 + i * 6, 24)
		right[i] = _sample(bytes, 44 + i * 6 + 3, 24)
	return [left, right]


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
