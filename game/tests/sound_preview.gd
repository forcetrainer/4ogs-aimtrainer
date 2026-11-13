extends Control
## A quick way to listen to the fight sounds without playing a run.
## Keys: 1 hit, 2 headshot, 3 kill, 4 one shot, 5 a burst with hits and a
## kill (as it sounds in a fight), 6 enemy burst to the left, 7 to the
## right, 8 behind. Esc quits.

const GunAudio = preload("res://scripts/gun_audio.gd")
const SpatialSteps = preload("res://scripts/spatial_steps.gd")
const Style = preload("res://scripts/ui/style.gd")

var audio: GunAudio
var steps: SpatialSteps


func _ready() -> void:
	audio = GunAudio.new()
	add_child(audio)
	steps = SpatialSteps.new()
	add_child(steps)
	set_anchors_preset(Control.PRESET_FULL_RECT)
	var bg := ColorRect.new()
	bg.color = Style.BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var text := Style.label("\n".join([
		"SOUND PREVIEW", "",
		"1   hit", "2   headshot", "3   kill", "4   one shot",
		"5   burst with hits and a kill", "6   enemy fire, left",
		"7   enemy fire, right", "8   enemy fire, behind", "9   headshot kill", "",
		"Q   footsteps, left", "W   footsteps, right", "E   footsteps, behind",
		"R   footsteps walking in from 16 m to 3 m, ahead and to the right", "", "Esc   quit"]), 26)
	text.theme = Style.theme()
	text.position = Vector2(80, 60)
	add_child(text)


func _burst(shots: int, with_hits: bool) -> void:
	for i in shots:
		audio.shot()
		if with_hits and i % 2 == 1:
			if i == shots - 1:
				audio.kill()
			else:
				audio.hit(false)
		await get_tree().create_timer(0.075).timeout


func _enemy(right_deg: float) -> void:
	for i in 4:
		audio.enemy_shot(right_deg, 15.0)
		await get_tree().create_timer(0.095).timeout


func _input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	match event.keycode:
		KEY_1: audio.hit(false)
		KEY_2: audio.hit(true)
		KEY_3: audio.kill()
		KEY_9: audio.kill(true)
		KEY_Q: _walk(-90.0, 5.0, 5.0)
		KEY_W: _walk(90.0, 5.0, 5.0)
		KEY_E: _walk(180.0, 5.0, 5.0)
		KEY_R: _walk(40.0, 16.0, 3.0)
		KEY_4: audio.shot()
		KEY_5: _burst(8, true)
		KEY_6: _enemy(-90.0)
		KEY_7: _enemy(90.0)
		KEY_8: _enemy(180.0)
		KEY_ESCAPE: get_tree().quit()


## Eight footsteps from one direction, moving from one distance to another.
func _walk(right_deg: float, from_m: float, to_m: float) -> void:
	for i in 8:
		steps.play_relative(right_deg, -8.0, lerpf(from_m, to_m, i / 7.0))
		await get_tree().create_timer(0.32).timeout
