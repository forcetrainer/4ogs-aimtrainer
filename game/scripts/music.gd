extends Node
## The menu music. It starts on its opening hit, and once past the opening
## it repeats for as long as anyone stays on the menus, with no gap or
## click where it comes round.
##
## The track is 100 beats a minute, four beats to a bar, so a bar is 2.4
## seconds. The first four bars (the hit and its aftermath) are heard once.
## After that, bars 5 to 36 repeat: one bar before the end of that stretch
## a second copy starts one bar before its beginning, in step with the
## first, and the two are cross-faded over that bar.

const PATH := "res://assets/audio/music/menu_theme.mp3"
const BUS := "Music"
const BAR := 2.4
const LOOP_START := BAR * 4.0
const LOOP_END := BAR * 36.0
const CROSSFADE := BAR
const LEVEL_DB := -9.0
const SILENT_DB := -60.0

var _voices: Array[AudioStreamPlayer] = []
var _current := 0
var _crossing := false
var _playing := false
var _fade: Tween


func _ready() -> void:
	if AudioServer.get_bus_index(BUS) == -1:
		AudioServer.add_bus()
		AudioServer.set_bus_name(AudioServer.bus_count - 1, BUS)
		AudioServer.set_bus_send(AudioServer.bus_count - 1, "Master")
	var stream: AudioStream = load(PATH) if ResourceLoader.exists(PATH) else null
	for i in 2:
		var voice := AudioStreamPlayer.new()
		voice.stream = stream
		voice.bus = BUS
		voice.volume_db = SILENT_DB
		add_child(voice)
		_voices.append(voice)
	_set_bus_db(LEVEL_DB)


func available() -> bool:
	return _voices[0].stream != null


func _set_bus_db(db: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(BUS), db)


## Start from the opening hit.
func start() -> void:
	_begin(0.0)


## Start from where the repeating part begins, skipping the opening hit
## (for coming back to the menu after a run).
func resume() -> void:
	_begin(LOOP_START)


func _begin(from: float) -> void:
	if not available():
		return
	if _fade:
		_fade.kill()
	for voice in _voices:
		voice.stop()
		voice.volume_db = SILENT_DB
	_current = 0
	_crossing = false
	_playing = true
	_voices[0].volume_db = 0.0
	_voices[0].play(from)
	if from > 0.0:
		_set_bus_db(SILENT_DB)
		_fade_bus(LEVEL_DB, 1.5)
	else:
		_set_bus_db(LEVEL_DB)


func is_playing() -> bool:
	return _playing


## Fade away and stop (when a run starts, so it does not sit on top of
## footsteps and gunfire).
func fade_out(seconds := 1.0) -> void:
	if not _playing:
		return
	_playing = false
	_fade_bus(SILENT_DB, seconds)
	_fade.tween_callback(func():
		for voice in _voices:
			voice.stop())


func _fade_bus(to_db: float, seconds: float) -> void:
	if _fade:
		_fade.kill()
	_fade = create_tween()
	_fade.tween_method(_set_bus_db, AudioServer.get_bus_volume_db(AudioServer.get_bus_index(BUS)),
		to_db, seconds)


## Where the voice that is carrying the tune has got to, in seconds.
func position() -> float:
	var voice := _voices[_current]
	return voice.get_playback_position() + AudioServer.get_time_since_last_mix()


func _process(_delta: float) -> void:
	if not _playing or _crossing:
		return
	if position() < LOOP_END - CROSSFADE:
		return
	# Bring the other copy in one bar before the repeat point, in step.
	_crossing = true
	var leaving := _voices[_current]
	var joining := _voices[1 - _current]
	joining.volume_db = SILENT_DB
	joining.play(LOOP_START - CROSSFADE + (position() - (LOOP_END - CROSSFADE)))
	var cross := create_tween().set_parallel(true)
	cross.tween_method(func(v: float): joining.volume_db = linear_to_db(maxf(v, 0.001)), 0.0, 1.0, CROSSFADE)
	cross.tween_method(func(v: float): leaving.volume_db = linear_to_db(maxf(v, 0.001)), 1.0, 0.0, CROSSFADE)
	cross.chain().tween_callback(func():
		leaving.stop()
		_current = 1 - _current
		_crossing = false)
