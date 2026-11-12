extends Node3D
## Listening test for footstep direction over headphones. An unseen source
## plays footsteps somewhere around you; turn to face it and click.
##
## Keys: left click = "it's there", H = switch between the headphone-rendered
## footsteps and Godot's plain left/right panning, Esc = quit.
##
## "-- --auto" runs an unattended check instead: it records what reaches the
## output for a source in front, behind and to the right in both modes,
## prints the numbers and quits.

const Sens = preload("res://scripts/sens.gd")
const AimState = preload("res://scripts/aim_state.gd")
const Config = preload("res://scripts/config.gd")
const Lighting = preload("res://scripts/lighting.gd")
const Synth = preload("res://scripts/footstep_synth.gd")
const SpatialSteps = preload("res://scripts/spatial_steps.gd")

const EYE := Vector3(0, 1.7, 0)
const SOURCE_DISTANCE := 8.0
const STEP_INTERVAL := 0.42
const TRIALS := 12

## Emitted on Esc when the test was opened from the menu.
signal exited
## Set by the menu; without it Esc closes the game.
var embedded := false

var aim := AimState.new()
var camera: Camera3D
var steps: SpatialSteps
var plain: AudioStreamPlayer3D
var marker: MeshInstance3D
var label: Label

var _hrtf := true
var _bearing := 0.0
var _start_offset := 0.0
var _trial := 0
var _trial_start_usec := 0
var _first_turn := 0.0
var _next_step := 0.0
var _reveal_until := 0.0
var _results: Array = []
var _last_line := ""
var _done := false


func _ready() -> void:
	var settings := Config.load_settings()
	var profile := Config.load_json("res://profiles/call_of_duty.json")
	aim.deg_per_count = Sens.degrees_per_count(profile.yaw_constant, settings.sensitivity)
	Input.use_accumulated_input = false

	Lighting.build(self)
	var ground := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(200, 200)
	ground.mesh = plane
	var ground_mat := StandardMaterial3D.new()
	ground_mat.albedo_color = Color(0.3, 0.31, 0.28)
	ground.material_override = ground_mat
	add_child(ground)

	camera = Camera3D.new()
	camera.position = EYE
	camera.keep_aspect = Camera3D.KEEP_HEIGHT
	camera.fov = Sens.horizontal_to_vertical_fov(settings.fov, 16.0 / 9.0)
	add_child(camera)
	camera.make_current()

	marker = MeshInstance3D.new()
	var ball := SphereMesh.new()
	ball.radius = 0.35
	ball.height = 0.7
	marker.mesh = ball
	var marker_mat := StandardMaterial3D.new()
	marker_mat.albedo_color = Color(1.0, 0.45, 0.1)
	marker_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	marker.material_override = marker_mat
	marker.visible = false
	add_child(marker)

	var layer := CanvasLayer.new()
	add_child(layer)
	label = Label.new()
	label.position = Vector2(24, 20)
	label.add_theme_font_size_override("font_size", 22)
	layer.add_child(label)
	var dot := ColorRect.new()
	dot.color = Color(1, 1, 1)
	dot.size = Vector2(4, 4)
	dot.position = get_viewport().get_visible_rect().size / 2.0 - Vector2(2, 2)
	layer.add_child(dot)

	steps = SpatialSteps.new()
	add_child(steps)
	# The comparison: the same footstep through Godot's own 3D player, which
	# only changes the level in each ear.
	plain = AudioStreamPlayer3D.new()
	plain.stream = Synth.mono_stream(0)
	plain.attenuation_model = AudioStreamPlayer3D.ATTENUATION_DISABLED
	add_child(plain)

	if "--auto" in OS.get_cmdline_user_args():
		_done = true
		_auto_check()
		return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_next_trial()


func _source_position(bearing_deg: float) -> Vector3:
	var b := deg_to_rad(bearing_deg)
	return EYE + Vector3(sin(b), 0.0, -cos(b)) * SOURCE_DISTANCE


func _play_step() -> void:
	var at := _source_position(_bearing)
	if _hrtf:
		steps.play_relative(wrapf(_bearing - aim.yaw_deg, -180.0, 180.0), 0.0, 0.0)
	else:
		plain.position = at
		plain.play()


func _next_trial() -> void:
	_trial += 1
	if _trial > TRIALS:
		_finish()
		return
	_start_offset = randf_range(-180.0, 180.0)
	_bearing = aim.yaw_deg + _start_offset
	marker.position = _source_position(_bearing)
	marker.visible = false
	_first_turn = 0.0
	_trial_start_usec = Time.get_ticks_usec()
	_next_step = 0.0


func _answer() -> void:
	var error := absf(wrapf(_bearing - aim.yaw_deg, -180.0, 180.0))
	var seconds := (Time.get_ticks_usec() - _trial_start_usec) / 1e6
	var right_way := signf(_first_turn) == signf(_start_offset)
	_results.append({
		"hrtf": _hrtf, "offset": _start_offset, "error": error, "seconds": seconds,
		"right_way": right_way,
	})
	_last_line = "Off by %d deg after %.1f s. It started %d deg to your %s%s." % [
		error, seconds, absf(_start_offset), "right" if _start_offset > 0.0 else "left",
		"" if right_way else "; you first turned the wrong way"]
	marker.visible = true
	_reveal_until = Time.get_ticks_msec() / 1000.0 + 1.5


func _finish() -> void:
	_done = true
	marker.visible = false
	var lines := ["Done.", ""]
	for mode: bool in [true, false]:
		var errors := []
		var times := []
		var right := 0
		var behind := 0
		var behind_right := 0
		for r: Dictionary in _results:
			if r.hrtf != mode:
				continue
			errors.append(r.error)
			times.append(r.seconds)
			right += int(r.right_way)
			if absf(r.offset) > 90.0:
				behind += 1
				behind_right += int(r.right_way)
		if errors.is_empty():
			continue
		lines.append("%s: %d trials" % ["Headphone rendering" if mode else "Plain panning", errors.size()])
		lines.append("   typical error %d deg, typical time %.1f s" % [
			Config.median(errors), Config.median(times)])
		lines.append("   first turn went the right way %d of %d (behind you: %d of %d)" % [
			right, errors.size(), behind_right, behind])
		lines.append("")
	lines.append("Esc = quit")
	label.text = "\n".join(lines)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var c: Vector2 = event.screen_relative
		aim.apply_counts(c.x, c.y)
		if absf(_first_turn) < 40.0:
			_first_turn += c.x
	elif event is InputEventMouseButton and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		if not _done and not marker.visible:
			_answer()
	elif event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			if embedded:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				exited.emit()
			else:
				get_tree().quit()
		elif event.keycode == KEY_H and not _done:
			_hrtf = not _hrtf


func _process(delta: float) -> void:
	camera.rotation = aim.camera_rotation()
	if _done:
		return
	var now := Time.get_ticks_msec() / 1000.0
	if marker.visible:
		if now >= _reveal_until:
			_next_trial()
	else:
		_next_step -= delta
		if _next_step <= 0.0:
			_next_step = STEP_INTERVAL
			_play_step()
	label.text = "\n".join([
		"Direction test %d of %d.  Wear headphones." % [mini(_trial, TRIALS), TRIALS],
		"Turn to face the footsteps, then left click.",
		"Mode: %s  [H]" % ("headphone rendering" if _hrtf else "plain left/right panning"),
		"", _last_line])


# ---------- unattended check ----------

func _auto_check() -> void:
	var capture := AudioEffectCapture.new()
	capture.buffer_length = 1.0
	AudioServer.add_bus_effect(0, capture)
	await get_tree().create_timer(0.5).timeout
	print("AUDIO mix rate %d Hz, driver %s" % [AudioServer.get_mix_rate(), AudioServer.get_driver_name()])
	var rows := {}
	for mode: bool in [true, false]:
		_hrtf = mode
		for bearing: float in [0.0, 180.0, 90.0, -90.0]:
			_bearing = bearing
			plain.position = _source_position(bearing)
			await get_tree().create_timer(0.2).timeout
			capture.clear_buffer()
			_play_step()
			await get_tree().create_timer(0.4).timeout
			var m := _measure(capture.get_buffer(capture.get_frames_available()))
			rows["%s %d" % ["hrtf" if mode else "pan", bearing]] = m
			print("AUDIO %-4s bearing %4d: left %.4f  right %.4f  brightness %.3f" % [
				"hrtf" if mode else "pan", bearing, m.left, m.right, m.bright])
	var ok := true
	var front: Dictionary = rows["hrtf 0"]
	var back: Dictionary = rows["hrtf 180"]
	var right: Dictionary = rows["hrtf 90"]
	var left: Dictionary = rows["hrtf -90"]
	if front.left <= 0.0005:
		ok = false
		print("AUDIO FAIL nothing reached the output")
	if right.right <= right.left * 1.3 or left.left <= left.right * 1.3:
		ok = false
		print("AUDIO FAIL a source to one side is not louder in that ear")
	if absf(front.bright - back.bright) < 0.05 * front.bright:
		ok = false
		print("AUDIO FAIL front and back sound the same with headphone rendering")
	var pf: Dictionary = rows["pan 0"]
	var pb: Dictionary = rows["pan 180"]
	print("AUDIO front/back tone difference: headphone rendering %.0f%%, plain panning %.0f%%" % [
		100.0 * absf(front.bright - back.bright) / maxf(front.bright, 1e-9),
		100.0 * absf(pf.bright - pb.bright) / maxf(pf.bright, 1e-9)])
	print("AUDIO RESULT %s" % ("ok" if ok else "failed"))
	get_tree().quit(0 if ok else 1)


## Loudness in each ear, and how much of the sound is high-pitched (the part
## that changes between front and back).
func _measure(frames: PackedVector2Array) -> Dictionary:
	var left := 0.0
	var right := 0.0
	var diff := 0.0
	var total := 0.0
	var prev := Vector2.ZERO
	for f: Vector2 in frames:
		left += f.x * f.x
		right += f.y * f.y
		var d := f - prev
		diff += d.length_squared()
		total += f.length_squared()
		prev = f
	var n := maxf(frames.size(), 1.0)
	return {"left": sqrt(left / n), "right": sqrt(right / n), "bright": diff / maxf(total, 1e-12)}
