extends SceneTree
## Unattended check that the fight sounds reach the output: plays each one
## and measures what comes out. Needs a real sound device, so run it without
## --headless:  godot --path game --script res://tests/gunfire_check.gd

const GunAudio = preload("res://scripts/gun_audio.gd")


func _initialize() -> void:
	var audio := GunAudio.new()
	root.add_child(audio)
	var capture := AudioEffectCapture.new()
	capture.buffer_length = 1.0
	AudioServer.add_bus_effect(0, capture)
	await create_timer(0.5).timeout
	var ok := true
	var plays := {
		"own shot": func(): audio.shot(),
		"hit": func(): audio.hit(false),
		"headshot": func(): audio.hit(true),
		"kill": func(): audio.kill(),
		"enemy ahead": func(): audio.enemy_shot(0.0, 8.0),
		"enemy right": func(): audio.enemy_shot(90.0, 8.0),
		"enemy left": func(): audio.enemy_shot(-90.0, 8.0),
		"enemy far right": func(): audio.enemy_shot(90.0, 32.0),
	}
	var levels := {}
	for name: String in plays:
		capture.clear_buffer()
		plays[name].call()
		await create_timer(0.45).timeout
		var frames := capture.get_buffer(capture.get_frames_available())
		var left := 0.0
		var right := 0.0
		for f: Vector2 in frames:
			left += f.x * f.x
			right += f.y * f.y
		var n := maxf(frames.size(), 1.0)
		levels[name] = Vector2(sqrt(left / n), sqrt(right / n))
		print("GUNFIRE %-16s left %.4f  right %.4f" % [name, levels[name].x, levels[name].y])
		if levels[name].length() < 0.0005:
			ok = false
			print("GUNFIRE FAIL %s is silent" % name)
	if levels["enemy right"].y <= levels["enemy right"].x * 1.3 \
			or levels["enemy left"].x <= levels["enemy left"].y * 1.3:
		ok = false
		print("GUNFIRE FAIL enemy fire to one side is not louder in that ear")
	if levels["enemy far right"].y >= levels["enemy right"].y * 0.6:
		ok = false
		print("GUNFIRE FAIL distant enemy fire is not quieter")
	print("GUNFIRE RESULT %s" % ("ok" if ok else "failed"))
	quit(0 if ok else 1)
