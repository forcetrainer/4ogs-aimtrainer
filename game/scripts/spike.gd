extends Node3D
## Phase 0 fidelity spike: raw mouse counts -> view rotation using a game
## profile's yaw constant, with on-screen readouts for checking cm/360
## against the real game and for seeing how input batches into frames.

const Sens = preload("res://scripts/sens.gd")
const AimState = preload("res://scripts/aim_state.gd")
const Telemetry = preload("res://scripts/telemetry.gd")

const PROFILE_PATH := "res://profiles/call_of_duty.json"
const SETTINGS_PATH := "user://settings.json"

var profile := {}
var settings := {"dpi": 800.0, "sensitivity": 5.0}
var aim := AimState.new()
var telemetry := Telemetry.new()
var camera: Camera3D
var hud: Label

var _events_in_frame := 0
var _max_events_in_frame := 0
var _events_this_second := 0
var _events_per_second := 0
var _frames_this_second := 0
var _fps := 0
var _second := 0.0


func _ready() -> void:
	profile = JSON.parse_string(FileAccess.get_file_as_string(PROFILE_PATH))
	_load_settings()
	_apply_sensitivity()
	# Deliver every mouse report separately instead of one merged event per frame.
	Input.use_accumulated_input = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_build_world()
	_build_hud()
	telemetry.open()


func _load_settings() -> void:
	if FileAccess.file_exists(SETTINGS_PATH):
		var saved = JSON.parse_string(FileAccess.get_file_as_string(SETTINGS_PATH))
		if saved is Dictionary:
			settings.merge(saved, true)


func _save_settings() -> void:
	var f := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(settings, "\t"))


func _apply_sensitivity() -> void:
	aim.deg_per_count = Sens.degrees_per_count(profile.yaw_constant, settings.sensitivity)


func _build_world() -> void:
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.09, 0.1, 0.12)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.6, 0.6, 0.65)
	var world_env := WorldEnvironment.new()
	world_env.environment = env
	add_child(world_env)

	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-50, 30, 0)
	add_child(sun)

	var floor_mesh := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(80, 80)
	floor_mesh.mesh = plane
	var floor_mat := StandardMaterial3D.new()
	floor_mat.albedo_color = Color(0.2, 0.22, 0.25)
	floor_mesh.material_override = floor_mat
	add_child(floor_mesh)

	# A pillar every 15 degrees, labelled with its bearing, so a full turn is visible.
	for i in 24:
		var bearing := i * 15
		var angle := deg_to_rad(bearing)
		var pos := Vector3(sin(angle), 0, -cos(angle)) * 20.0
		var pillar := MeshInstance3D.new()
		var box := BoxMesh.new()
		box.size = Vector3(0.4, 4.0 if bearing % 90 == 0 else 2.5, 0.4)
		pillar.mesh = box
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(0.9, 0.35, 0.2) if bearing == 0 else Color(0.75, 0.78, 0.8)
		pillar.material_override = mat
		pillar.position = pos + Vector3(0, box.size.y / 2.0, 0)
		add_child(pillar)
		var label := Label3D.new()
		label.text = str(bearing)
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		label.pixel_size = 0.02
		label.position = pos + Vector3(0, box.size.y + 0.8, 0)
		add_child(label)

	camera = Camera3D.new()
	camera.position = Vector3(0, 1.7, 0)
	camera.keep_aspect = Camera3D.KEEP_HEIGHT
	camera.fov = _vertical_fov()
	add_child(camera)
	camera.make_current()


func _vertical_fov() -> float:
	if profile.fov_convention == "horizontal_at_16_9":
		return Sens.horizontal_to_vertical_fov(profile.fov_degrees, 16.0 / 9.0)
	return profile.fov_degrees


func _build_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	hud = Label.new()
	hud.position = Vector2(24, 20)
	hud.add_theme_font_size_override("font_size", 20)
	layer.add_child(hud)
	var dot := ColorRect.new()
	dot.color = Color(0.2, 1.0, 0.4)
	dot.size = Vector2(4, 4)
	dot.set_anchors_preset(Control.PRESET_CENTER)
	dot.position -= dot.size / 2.0
	layer.add_child(dot)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			return
		# screen_relative is unscaled by the viewport; in captured mode it is raw counts.
		var c: Vector2 = event.screen_relative
		aim.apply_counts(c.x, c.y)
		_events_in_frame += 1
		_events_this_second += 1
		telemetry.log_event("move", c.x, c.y, aim.yaw_deg, aim.pitch_deg)
	elif event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			telemetry.log_event("click", 0, 0, aim.yaw_deg, aim.pitch_deg)
	elif event is InputEventKey and event.pressed and not event.echo:
		var step := 0.5 if event.shift_pressed else 0.05
		match event.keycode:
			KEY_ESCAPE:
				_quit()
			KEY_R:
				aim.reset()
			KEY_BRACKETLEFT:
				_set_sensitivity(settings.sensitivity - step)
			KEY_BRACKETRIGHT:
				_set_sensitivity(settings.sensitivity + step)
			KEY_MINUS:
				_set_dpi(settings.dpi - 50.0)
			KEY_EQUAL:
				_set_dpi(settings.dpi + 50.0)


func _set_sensitivity(value: float) -> void:
	settings.sensitivity = clampf(snappedf(value, 0.01), 0.01, 100.0)
	_apply_sensitivity()
	_save_settings()


func _set_dpi(value: float) -> void:
	settings.dpi = clampf(value, 50.0, 64000.0)
	_save_settings()


func _process(delta: float) -> void:
	camera.rotation = aim.camera_rotation()
	_max_events_in_frame = maxi(_max_events_in_frame, _events_in_frame)
	_events_in_frame = 0
	_frames_this_second += 1
	_second += delta
	if _second >= 1.0:
		_events_per_second = _events_this_second
		_fps = _frames_this_second
		_events_this_second = 0
		_frames_this_second = 0
		_second = 0.0
		telemetry.flush()
	hud.text = _hud_text()


func _hud_text() -> String:
	var dpi: float = settings.dpi
	var sens: float = settings.sensitivity
	var lines := [
		"%s profile   yaw %.4f   FOV %.0f (%s)" % [
			profile.name, profile.yaw_constant, profile.fov_degrees, profile.fov_convention],
		"DPI %d  [- / =]     sensitivity %.2f  [ [ / ] , Shift = coarse ]" % [dpi, sens],
		"cm/360: %.2f     counts/360: %.1f" % [
			Sens.cm_per_360(dpi, profile.yaw_constant, sens),
			Sens.counts_per_360(profile.yaw_constant, sens)],
		"",
		"Turned: %.2f deg  (%.3f turns)     pitch %.2f" % [
			aim.yaw_deg, aim.yaw_deg / 360.0, aim.pitch_deg],
		"Net counts x: %d     hand travel: %.2f cm net, %.2f cm total" % [
			aim.counts_x, Sens.counts_to_cm(aim.counts_x, dpi),
			Sens.counts_to_cm(aim.abs_counts_x, dpi)],
		"",
		"%d fps     mouse events/s: %d     max events in one frame: %d" % [
			_fps, _events_per_second, _max_events_in_frame],
		"",
		"R = reset counters     Esc = quit",
		"Log: %s" % telemetry.path,
	]
	return "\n".join(lines)


func _quit() -> void:
	telemetry.close()
	get_tree().quit()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		telemetry.close()
