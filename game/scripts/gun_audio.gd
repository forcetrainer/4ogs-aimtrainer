extends Node
## Everything you hear in a fight: your own gunfire, the hit and kill
## confirmations, and enemy fire coming from where the enemy is.
##
## Gunfire is from field recordings of a 9 mm submachine gun, cut up by
## tests/tools_make_gunfire.gd. Enemy shots were rendered in advance for
## every 10 degrees around a dummy head, like the footsteps, so direction
## works over headphones at any output rate. The hit and kill sounds are
## made here from scratch: short, dry and unlike anything in the world, so
## they cut through gunfire.

const DIR := "res://assets/audio/gunfire"
const RATE := 48000
const PLAYER_VARIANTS := 5
const ENEMY_VARIANTS := 2
const AZIMUTH_STEP := 10
const SHOT_VOICES := 8
const ENEMY_VOICES := 6
const SHOT_DB := -5.0
const CONFIRM_DB := -8.0
## Distance at which enemy fire plays at full level; it falls 6 dB per
## doubling beyond that.
const ENEMY_FULL_LEVEL_M := 8.0
const ENEMY_DB := -2.0

const BUS := "Gunfire"
const TAIL_VOICES := 4
const PUNCH_DB := -7.0
const TAIL_DB := -17.0

var _shots: Array = []
var _tails: Array = []
var _punch: AudioStreamWAV
var _punch_voices: Array[AudioStreamPlayer] = []
var _tail_voices: Array[AudioStreamPlayer] = []
var _next_tail := 0
var _enemy := {}
var _shot_voices: Array[AudioStreamPlayer] = []
var _enemy_voices: Array[AudioStreamPlayer] = []
var _confirm: AudioStreamPlayer
var _next_shot := 0
var _next_enemy := 0
var _hit: AudioStreamWAV
var _head: AudioStreamWAV
var _kill: AudioStreamWAV
var _head_kill: AudioStreamWAV


func _ready() -> void:
	for i in PLAYER_VARIANTS:
		var path := "%s/player_%d.wav" % [DIR, i]
		if ResourceLoader.exists(path):
			_shots.append(load(path))
	for azi in range(0, 360, AZIMUTH_STEP):
		var streams := []
		for v in ENEMY_VARIANTS:
			var path := "%s/enemy_%d_azi_%d.wav" % [DIR, v, azi]
			if ResourceLoader.exists(path):
				streams.append(load(path))
		_enemy[azi] = streams
	for i in 8:
		var path := "%s/tail_%d.wav" % [DIR, i]
		if ResourceLoader.exists(path):
			_tails.append(load(path))
	_punch = punch_stream()
	_setup_bus()
	for i in SHOT_VOICES:
		_shot_voices.append(_voice())
		_punch_voices.append(_voice())
	for i in TAIL_VOICES:
		_tail_voices.append(_voice())
	for i in ENEMY_VOICES:
		_enemy_voices.append(_voice())
	_confirm = AudioStreamPlayer.new()
	_confirm.volume_db = CONFIRM_DB
	add_child(_confirm)
	_hit = thwack_stream(HIT)
	_head = thwack_stream(HEADSHOT)
	_kill = thwack_stream(KILL)
	_head_kill = thwack_stream(HEADSHOT_KILL)


## One of your own shots. Small changes of pitch and level keep automatic
## fire from sounding like one sample on repeat.
func shot() -> void:
	if _shots.is_empty():
		return
	var voice := _shot_voices[_next_shot]
	_next_shot = (_next_shot + 1) % SHOT_VOICES
	voice.stream = _shots[randi() % _shots.size()]
	voice.pitch_scale = randf_range(0.96, 1.04)
	voice.volume_db = SHOT_DB + randf_range(-1.0, 0.5)
	voice.play()
	# Weight: a low thump the recording lacks.
	var punch := _punch_voices[_next_shot]
	punch.stream = _punch
	punch.pitch_scale = randf_range(0.94, 1.06)
	punch.volume_db = PUNCH_DB
	punch.play()
	# Distance: the same shot as heard from further off, rolling away.
	if not _tails.is_empty():
		var tail := _tail_voices[_next_tail]
		_next_tail = (_next_tail + 1) % TAIL_VOICES
		tail.stream = _tails[randi() % _tails.size()]
		tail.pitch_scale = randf_range(0.93, 1.0)
		tail.volume_db = TAIL_DB
		tail.play()


func _voice() -> AudioStreamPlayer:
	var p := AudioStreamPlayer.new()
	p.bus = BUS
	add_child(p)
	return p


## All gunfire goes through one mixer channel that gives it the place it is
## fired in: more low end, an echo off the yard wall, and a short reverb.
func _setup_bus() -> void:
	if AudioServer.get_bus_index(BUS) != -1:
		return
	AudioServer.add_bus()
	var index := AudioServer.bus_count - 1
	AudioServer.set_bus_name(index, BUS)
	AudioServer.set_bus_send(index, "Master")
	var eq := AudioEffectEQ6.new()
	eq.set_band_gain_db(0, 3.0)   # 32 Hz
	eq.set_band_gain_db(1, 5.0)   # 100 Hz
	eq.set_band_gain_db(2, 2.0)   # 320 Hz
	eq.set_band_gain_db(4, -1.5)  # 3.2 kHz: take a little of the thin crack off
	AudioServer.add_bus_effect(index, eq)
	# The wall is 46 m away: sound takes about 0.27 s to go there and back.
	var echo := AudioEffectDelay.new()
	echo.dry = 1.0
	echo.tap1_active = true
	echo.tap1_delay_ms = 270.0
	echo.tap1_level_db = -26.0
	echo.tap1_pan = -0.3
	echo.tap2_active = false
	echo.tap2_delay_ms = 390.0
	echo.tap2_level_db = -20.0
	echo.tap2_pan = 0.35
	echo.feedback_active = false
	AudioServer.add_bus_effect(index, echo)
	var reverb := AudioEffectReverb.new()
	reverb.room_size = 0.4
	reverb.damping = 0.65
	reverb.spread = 0.9
	reverb.predelay_msec = 25.0
	reverb.hipass = 0.15
	reverb.dry = 1.0
	reverb.wet = 0.07
	AudioServer.add_bus_effect(index, reverb)
	var limit := AudioEffectHardLimiter.new()
	limit.ceiling_db = -1.0
	AudioServer.add_bus_effect(index, limit)


## The low thump under each shot: a pitch falling from about 120 to 45 Hz
## in under a tenth of a second.
static func punch_stream() -> AudioStreamWAV:
	var n := int(0.11 * RATE)
	var mix := PackedFloat32Array()
	mix.resize(n)
	_add_thump(mix, 0, 1.0, 125.0, 45.0, 0.04)
	var data := PackedByteArray()
	data.resize(n * 2)
	var fade := int(RATE * 0.01)
	for i in n:
		var edge := minf(float(n - i) / fade, 1.0) * minf(float(i) / (RATE * 0.001), 1.0)
		data.encode_s16(i * 2, int(clampf(mix[i], -1.0, 1.0) * edge * 29000.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = RATE
	wav.stereo = false
	wav.data = data
	return wav


func hit(headshot: bool) -> void:
	_confirm.stream = _head if headshot else _hit
	_confirm.pitch_scale = randf_range(0.98, 1.03)
	_confirm.play()


func kill(headshot := false) -> void:
	_confirm.stream = _head_kill if headshot else _kill
	_confirm.pitch_scale = 1.0
	_confirm.play()


## The stored direction nearest to an enemy `right_deg` to the right of
## where the player faces. Stored azimuths run anticlockwise from ahead.
static func snap(right_deg: float) -> int:
	return int(roundf(wrapf(-right_deg, 0.0, 360.0) / AZIMUTH_STEP)) * AZIMUTH_STEP % 360


static func enemy_level_db(distance_m: float) -> float:
	return ENEMY_DB - 20.0 * log(maxf(distance_m, ENEMY_FULL_LEVEL_M) / ENEMY_FULL_LEVEL_M) / log(10.0)


## One enemy shot, heard from `right_deg` to the right of where the player
## is facing (beyond +/-90 is behind) at `distance_m`.
func enemy_shot(right_deg: float, distance_m: float) -> void:
	var streams: Array = _enemy.get(snap(right_deg), [])
	if streams.is_empty():
		return
	var voice := _enemy_voices[_next_enemy]
	_next_enemy = (_next_enemy + 1) % ENEMY_VOICES
	voice.stream = streams[randi() % streams.size()]
	voice.pitch_scale = randf_range(0.95, 1.05)
	voice.volume_db = enemy_level_db(distance_m)
	voice.play()


# ---------- hit and kill sounds ----------
#
# A "thwack" is noise, not a note: a hard click, a snap of bright noise that
# is gone in a hundredth of a second, a slightly longer puff of mid noise
# for the body, and a low thump that drops in pitch too fast to be heard as
# a tone. Nothing here holds a steady pitch, which is what made the first
# version sound like a beep.
#
# Each layer: [centre Hz, sharpness, decay seconds, level]. `thump` is
# [start Hz, end Hz, decay seconds, level]. `echo` repeats the whole thing
# once, later and quieter, which gives the kill its heavier double knock.

const HIT := {
	"seconds": 0.085,
	"snap": [2300.0, 1.4, 0.008, 1.0],
	"body": [560.0, 1.1, 0.02, 0.9],
	"thump": [210.0, 70.0, 0.022, 0.55],
	"echo": [0.0, 0.0],
}
const HEADSHOT := {
	"seconds": 0.085,
	"snap": [3800.0, 1.6, 0.009, 1.2],
	"body": [820.0, 1.2, 0.016, 0.8],
	"thump": [240.0, 90.0, 0.018, 0.4],
	"echo": [0.0, 0.0],
}
# A kill is one event, not two: the same thwack with far more weight under
# it and a rougher, longer body, so it lands as a thud.
const KILL := {
	"seconds": 0.17,
	"snap": [1500.0, 1.1, 0.01, 0.8],
	"body": [300.0, 0.8, 0.045, 1.2],
	"thump": [130.0, 42.0, 0.075, 1.3],
	"echo": [0.0, 0.0],
}
# A headshot kill adds a short, high, slightly metallic "tink" on top. Its
# three pitches are not in tune with each other, which is what makes it a
# tink and not a beep, and it is gone in a twentieth of a second.
const HEADSHOT_KILL := {
	"seconds": 0.17,
	"snap": [2600.0, 1.3, 0.009, 0.9],
	"body": [420.0, 0.9, 0.035, 1.0],
	"thump": [150.0, 50.0, 0.06, 1.1],
	"echo": [0.0, 0.0],
	"ring": [[3350.0, 0.5], [5120.0, 0.32], [7400.0, 0.18]],
	"ring_decay": 0.028,
}


static func thwack_stream(spec: Dictionary) -> AudioStreamWAV:
	var n := int(float(spec.seconds) * RATE)
	var mix := PackedFloat32Array()
	mix.resize(n)
	var rng := RandomNumberGenerator.new()
	rng.seed = int(spec.snap[0] + spec.body[0])
	var echo_at := int(float(spec.echo[0]) * RATE)
	var starts := [[0, 1.0]]
	if echo_at > 0:
		starts.append([echo_at, float(spec.echo[1])])
	for start: Array in starts:
		for layer: Array in [spec.snap, spec.body]:
			_add_noise_band(mix, rng, int(start[0]), float(start[1]) * float(layer[3]),
				float(layer[0]), float(layer[1]), float(layer[2]))
		_add_thump(mix, int(start[0]), float(start[1]) * float(spec.thump[3]),
			float(spec.thump[0]), float(spec.thump[1]), float(spec.thump[2]))
		for partial: Array in spec.get("ring", []):
			var phase := 0.0
			for i in range(int(start[0]), n):
				var t := float(i - int(start[0])) / RATE
				phase += TAU * float(partial[0]) / RATE
				mix[i] += sin(phase) * exp(-t / float(spec.ring_decay)) * float(partial[1])
		# The click that gives the front edge its bite.
		for i in mini(int(RATE * 0.0012), n - int(start[0])):
			mix[int(start[0]) + i] += rng.randf_range(-1.0, 1.0) * float(start[1]) * 0.9
	# Push it into a soft limit so it sounds hit rather than played, then
	# bring the loudest point to a fixed level.
	var peak := 0.0
	for i in n:
		mix[i] = tanh(mix[i] * 1.6)
		peak = maxf(peak, absf(mix[i]))
	var data := PackedByteArray()
	data.resize(n * 2)
	var fade := int(RATE * 0.004)
	for i in n:
		var edge := minf(float(n - i) / fade, 1.0)
		data.encode_s16(i * 2, int(mix[i] / maxf(peak, 1e-9) * edge * 29000.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = RATE
	wav.stereo = false
	wav.data = data
	return wav


## Noise squeezed into a band round `hz`, dying away over `decay` seconds.
static func _add_noise_band(mix: PackedFloat32Array, rng: RandomNumberGenerator, start: int,
		level: float, hz: float, q: float, decay: float) -> void:
	var w := TAU * hz / RATE
	var alpha := sin(w) / (2.0 * q)
	var b0 := alpha / (1.0 + alpha)
	var a1 := -2.0 * cos(w) / (1.0 + alpha)
	var a2 := (1.0 - alpha) / (1.0 + alpha)
	var x1 := 0.0
	var x2 := 0.0
	var y1 := 0.0
	var y2 := 0.0
	for i in range(start, mix.size()):
		var t := float(i - start) / RATE
		var x := rng.randf_range(-1.0, 1.0)
		var y := b0 * x - b0 * x2 - a1 * y1 - a2 * y2
		x2 = x1
		x1 = x
		y2 = y1
		y1 = y
		mix[i] += y * exp(-t / decay) * level * 2.2


## A low knock whose pitch falls from `from_hz` to `to_hz` almost at once.
static func _add_thump(mix: PackedFloat32Array, start: int, level: float, from_hz: float,
		to_hz: float, decay: float) -> void:
	var phase := 0.0
	for i in range(start, mix.size()):
		var t := float(i - start) / RATE
		phase += TAU * (to_hz + (from_hz - to_hz) * exp(-t / (decay * 0.5))) / RATE
		mix[i] += sin(phase) * exp(-t / decay) * level
