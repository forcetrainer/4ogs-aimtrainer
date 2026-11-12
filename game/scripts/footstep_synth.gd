extends RefCounted
## Placeholder footstep sounds made from noise: a low thud with a short
## gritty scuff. Broad in pitch on purpose, because the cues that tell front
## from back live in the high frequencies.

const MIX_RATE := 48000
const VARIANTS := 3
const SECONDS := 0.14


## Samples in the range -1..1 for one footstep; each variant sounds a
## little different so repeated steps do not sound mechanical.
static func samples(variant: int) -> PackedFloat32Array:
	var rng := RandomNumberGenerator.new()
	rng.seed = 3 + variant * 101
	var count := int(MIX_RATE * SECONDS)
	var out := PackedFloat32Array()
	out.resize(count)
	var low := 0.0
	var thud_decay := 38.0 + 6.0 * variant
	var scuff_decay := 55.0 - 7.0 * variant
	for i in count:
		var t := float(i) / MIX_RATE
		var noise := rng.randf_range(-1.0, 1.0)
		low += (noise - low) * 0.08
		var thud := low * 2.2 * exp(-t * thud_decay)
		var scuff := noise * 0.55 * exp(-t * scuff_decay) * minf(t * 400.0, 1.0)
		out[i] = clampf(thud + scuff, -1.0, 1.0) * 0.8
	return out


## The same footstep as a one-channel sound, for plain (non-headphone) playback.
static func mono_stream(variant: int) -> AudioStreamWAV:
	var s := samples(variant)
	var data := PackedByteArray()
	data.resize(s.size() * 2)
	for i in s.size():
		data.encode_s16(i * 2, int(s[i] * 32000.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = MIX_RATE
	wav.stereo = false
	wav.data = data
	return wav
