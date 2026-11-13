extends SceneTree
## Unattended check of the menu music: that it starts loud on its opening
## hit, and that where it comes round to repeat there is no gap. Needs a
## real sound device, so run it without --headless:
##   godot --path game --script res://tests/music_check.gd

const Music = preload("res://scripts/music.gd")


func _rms(frames: PackedVector2Array) -> float:
	var sum := 0.0
	for f: Vector2 in frames:
		sum += f.x * f.x + f.y * f.y
	return sqrt(sum / maxf(frames.size() * 2.0, 1.0))


func _initialize() -> void:
	var music := Music.new()
	root.add_child(music)
	var capture := AudioEffectCapture.new()
	capture.buffer_length = 1.0
	AudioServer.add_bus_effect(0, capture)
	await create_timer(0.3).timeout
	var ok := true

	capture.clear_buffer()
	music.start()
	await create_timer(0.25).timeout
	var opening := _rms(capture.get_buffer(capture.get_frames_available()))
	print("MUSICCHECK first quarter second: level %.4f" % opening)
	if opening < 0.003:
		ok = false
		print("MUSICCHECK FAIL the opening is not there straight away")

	# Jump to just before the repeat and listen across it in tenths of a second.
	var voice: AudioStreamPlayer = music._voices[music._current]
	voice.seek(Music.LOOP_END - Music.CROSSFADE - 1.0)
	await create_timer(0.2).timeout
	var levels := []
	for i in 50:
		capture.clear_buffer()
		await create_timer(0.1).timeout
		levels.append(_rms(capture.get_buffer(capture.get_frames_available())))
	var lowest: float = levels.min()
	var total := 0.0
	for v: float in levels:
		total += v
	var average := total / levels.size()
	print("MUSICCHECK across the repeat: average %.4f, lowest tenth of a second %.4f (%.0f%% of average)" % [
		average, lowest, 100.0 * lowest / maxf(average, 1e-9)])
	if lowest < average * 0.35:
		ok = false
		print("MUSICCHECK FAIL there is a dip where it repeats")
	var now := music.position()
	print("MUSICCHECK after the repeat the tune is at %.1f s" % now)
	if now < Music.LOOP_START or now > Music.LOOP_START + 6.0:
		ok = false
		print("MUSICCHECK FAIL it did not come back to the start of the repeating part")

	music.fade_out(0.4)
	await create_timer(0.8).timeout
	capture.clear_buffer()
	await create_timer(0.2).timeout
	var after := _rms(capture.get_buffer(capture.get_frames_available()))
	print("MUSICCHECK after fading out: level %.5f" % after)
	if after > 0.0005:
		ok = false
		print("MUSICCHECK FAIL it is still audible after fading out")
	print("MUSICCHECK %s" % ("ok" if ok else "failed"))
	quit(0 if ok else 1)
