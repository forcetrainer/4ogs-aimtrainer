extends Node
## Footsteps you can locate over headphones. Each step is a short stereo
## sound rendered in advance for one direction around a dummy head (see
## tests/tools_render_footsteps.gd); playing the one nearest to where the
## source is, relative to where the player is facing, gives left/right,
## front/back and some up/down. Because the sounds are ordinary stereo files
## this works at any output rate and needs no audio add-on.
##
## The direction is fixed for the length of one step (0.28 s); turning
## changes what the next step sounds like.

## How many different recorded steps there are for each direction.
const VARIANTS := 4

const DIR := "res://assets/audio/footsteps_hrtf"
## Stored directions: elevation in degrees -> spacing around, in degrees.
const GRID := {-30: 15, 0: 5, 30: 15}
const VOICES := 6
## Footsteps are a close sound. A step plays at full level within
## FULL_LEVEL_M, falls 6 dB per doubling beyond that and a further 1.5 dB
## per metre past FADE_FROM_M, and cannot be heard at all past RANGE_M.
const FULL_LEVEL_M := 4.0
const FADE_FROM_M := 9.0
const RANGE_M := 16.0

var _bank := {}
var _voices: Array[AudioStreamPlayer] = []
var _next_voice := 0


func _ready() -> void:
	for ele: int in GRID:
		for azi in range(0, 360, GRID[ele]):
			var streams := []
			for v in VARIANTS:
				streams.append(load("%s/step%d_azi_%d_ele_%d.wav" % [DIR, v, azi, ele]))
			_bank[Vector2i(azi, ele)] = streams
	for i in VOICES:
		var p := AudioStreamPlayer.new()
		add_child(p)
		_voices.append(p)


## The stored direction nearest to a source that is `right_deg` to the right
## of where the listener faces (negative = left, beyond +/-90 = behind) and
## `up_deg` above ear level. Returns (azimuth, elevation) as stored:
## azimuth runs anticlockwise from straight ahead.
static func snap(right_deg: float, up_deg: float) -> Vector2i:
	var ele := 0
	if up_deg >= 15.0:
		ele = 30
	elif up_deg <= -15.0:
		ele = -30
	var step: int = GRID[ele]
	var azi := int(roundf(wrapf(-right_deg, 0.0, 360.0) / step)) * step % 360
	return Vector2i(azi, ele)


static func level_db(distance_m: float) -> float:
	var spread := -20.0 * log(maxf(distance_m, FULL_LEVEL_M) / FULL_LEVEL_M) / log(10.0)
	return spread - maxf(distance_m - FADE_FROM_M, 0.0) * 1.5


static func audible(distance_m: float) -> bool:
	return distance_m <= RANGE_M


## Play one footstep from a direction relative to the listener's facing.
func play_relative(right_deg: float, up_deg: float, distance_m: float) -> void:
	if not audible(distance_m):
		return
	var streams: Array = _bank[snap(right_deg, up_deg)]
	var voice := _voices[_next_voice]
	_next_voice = (_next_voice + 1) % VOICES
	voice.stream = streams[randi() % streams.size()]
	voice.volume_db = level_db(distance_m)
	voice.play()


## Play one footstep from a place in the world, heard from `ear` by a
## listener facing `yaw_deg` (0 = along -Z, positive = turned right).
func play_at(source: Vector3, ear: Vector3, yaw_deg: float) -> void:
	var to := source - ear
	var flat := Vector2(to.x, to.z).length()
	var bearing := rad_to_deg(atan2(to.x, -to.z))
	play_relative(wrapf(bearing - yaw_deg, -180.0, 180.0),
		rad_to_deg(atan2(to.y, maxf(flat, 0.001))), to.length())
