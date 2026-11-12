extends Node3D
## Engagement drill. Each fight starts at an unpredictable moment with a
## target placed relative to what the player can currently see (centre, mid,
## edge of screen, just off screen, or behind), in a random stance. A second
## target may stack in while the first is still alive. Turn, raise the sight,
## hold fire through recoil. Every stage is timed from each target's cue.
##
## An enemy "kills you" if it stays alive longer than its time-to-kill; that
## time adapts per drill so you win about 70% of fights, and is your level.

const Sens = preload("res://scripts/sens.gd")
const AimState = preload("res://scripts/aim_state.gd")
const Config = preload("res://scripts/config.gd")
const Geo = preload("res://scripts/target_geometry.gd")
const Target = preload("res://scripts/target.gd")
const Lighting = preload("res://scripts/lighting.gd")
const Viewmodel = preload("res://scripts/viewmodel.gd")

enum State { WAITING, ACTIVE, SUMMARY }

const DRILLS := ["mixed", "peripheral", "offscreen"]
## Reporting bins. Vision falls off smoothly with no natural breakpoints, so
## on-screen results are grouped in log-spaced rings of visual angle and the
## exact angle and direction of every target are logged for curve fitting.
const ZONE_NAMES := {
	"0-2.5": "within 2.5 deg", "2.5-5": "2.5 to 5 deg", "5-10": "5 to 10 deg",
	"10-20": "10 to 20 deg", "20+": "beyond 20 deg",
	"offscreen": "just off screen", "behind": "behind you",
}
## Where a drill asks for targets: rings of the player's own visual field,
## in degrees of visual angle between the crosshair and the target as seen
## from the eye (set by monitor size and viewing distance, not game FOV).
## "far" runs out to the edge of the screen.
const VISUAL_ZONES := {"center": [0.5, 5.0], "mid": [5.0, 10.0], "far": [10.0, 90.0]}
const RUN_LENGTH := 20
const EYE := Vector3(0, 1.7, 0)
const MIN_DISTANCE := 10.0
const MAX_DISTANCE := 35.0
const MOVE_THRESHOLD_COUNTS := 4.0
# One-up one-down staircase; step ratio 7:3 settles near a 70% win rate.
const WIN_STEP := 0.97
const LOSS_STEP := 1.07
const MIN_ENEMY_TTK_MS := 300.0
const MAX_ENEMY_TTK_MS := 5000.0
## Visual-only weapon motion; the true aim point never moves with these.
const KICK_BACK_M := 0.012
const KICK_UP_DEG := 0.7
const KICK_DECAY_PER_S := 14.0
const SWAY_M_PER_DEG := 0.0012
const SWAY_MAX_M := 0.02

var profile := {}
var weapon := {}
var settings := {}
var drill := {}
var drill_id := "mixed"
var aim := AimState.new()
var state := State.WAITING

var camera: Camera3D
var gun: Node3D
var optic: Node3D
var muzzle_flash: MeshInstance3D
var _gun_hip_pos := Vector3.ZERO
var _gun_irons_pos := Vector3.ZERO
var _gun_optic_pos := Vector3.ZERO
var _gun_irons_pitch := 0.0
var _gun_lens: Node3D
var _gun_hip_rot := Vector3.ZERO
var _gun_tan_half_fov := 0.466
var _gun_mesh: MeshInstance3D
var _mount_surface := -1
var _kick := 0.0
var _sway := Vector2.ZERO
var _last_yaw := 0.0
var _last_pitch := 0.0
var _force_ads := false

var status_label: Label
var result_label: Label
var summary_label: Label
var hit_marker: Label
var crosshair: ColorRect
var cue_left: ColorRect
var cue_right: ColorRect
var damage_overlay: ColorRect

var _sun_dir := Vector3.UP
var _base_deg_per_count := 0.0
var _ads_progress := 0.0
var _ads_multiplier := 1.0
var _hip_hfov := 110.0
var _ads_hfov := 90.0
var _next_shot_usec := 0
var _flash_until_usec := 0
var _marker_until_usec := 0
var _cue_until_usec := 0
var _overlay_until_usec := 0
var _wait_until_usec := 0

var _targets: Array = []
var _fight_recs: Array = []
var _first_rec := {}
var _stack_at_usec := 0
var _fight_ttk := 0.0
var _fights_done := 0
var _wins := 0
var _run_recs: Array = []
var _run_start_ttk := 0.0
var _log: FileAccess


func _ready() -> void:
	profile = Config.load_json("res://profiles/call_of_duty.json")
	weapon = Config.load_json("res://weapons/mp5.json")
	settings = Config.load_settings()
	Input.use_accumulated_input = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_build_world()
	_build_gun()
	_build_hud()
	_apply_settings()
	_open_log()
	_load_drill(settings.get("drill", "mixed"))
	_screenshot_if_requested()


# ---------- setup ----------

func _apply_settings() -> void:
	_base_deg_per_count = Sens.degrees_per_count(profile.yaw_constant, settings.sensitivity)
	_hip_hfov = settings.fov
	_ads_hfov = Sens.zoomed_fov(_hip_hfov, weapon.zoom)
	var aspect := 16.0 / 9.0
	_ads_multiplier = Sens.relative_ads_multiplier(
		Sens.horizontal_to_vertical_fov(_hip_hfov, aspect),
		Sens.horizontal_to_vertical_fov(_ads_hfov, aspect),
		profile.ads_monitor_coefficient)


func _load_drill(id: String) -> void:
	drill_id = id if id in DRILLS else "mixed"
	drill = Config.load_json("res://drills/%s.json" % drill_id)
	settings["drill"] = drill_id
	if not settings.has(_ttk_key()):
		settings[_ttk_key()] = float(drill.start_enemy_ttk_ms)
	Config.save_settings(settings)
	_start_run()


func _ttk_key() -> String:
	return "enemy_ttk_ms_" + drill_id


func _build_world() -> void:
	_sun_dir = Lighting.build(self)

	var ground := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(200, 200)
	ground.mesh = plane
	ground.material_override = _flat_material(Color(0.3, 0.31, 0.28))
	add_child(ground)

	# Distant blocks give the eye a sense of rotation; targets always spawn nearer.
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	for i in 28:
		var angle := rng.randf_range(0.0, TAU)
		var dist := rng.randf_range(48.0, 85.0)
		var block := MeshInstance3D.new()
		var box := BoxMesh.new()
		box.size = Vector3(rng.randf_range(3, 9), rng.randf_range(2.5, 9), rng.randf_range(3, 9))
		block.mesh = box
		var shade := rng.randf_range(0.34, 0.52)
		block.material_override = _flat_material(Color(shade, shade * 0.97, shade * 0.9))
		block.position = Vector3(sin(angle) * dist, box.size.y / 2.0, -cos(angle) * dist)
		add_child(block)

	camera = Camera3D.new()
	camera.position = EYE
	camera.keep_aspect = Camera3D.KEEP_HEIGHT
	camera.near = 0.03
	add_child(camera)
	camera.make_current()


func _flat_material(color: Color, roughness := 0.9, metallic := 0.0) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = roughness
	mat.metallic = metallic
	return mat


## Development aid: "-- --screenshot=<path>" saves one frame and quits;
## add "--look-sun" to face the sun and check the shadows agree with the sky.
func _screenshot_if_requested() -> void:
	var path := ""
	var args := OS.get_cmdline_user_args()
	for arg: String in args:
		if arg.begins_with("--screenshot="):
			path = arg.trim_prefix("--screenshot=")
	if path == "":
		return
	_force_ads = "--ads" in args
	if "--irons" in args:
		_set_optic(false)
	if "--look-sun" in args:
		aim.yaw_deg = rad_to_deg(atan2(_sun_dir.x, -_sun_dir.z))
		aim.pitch_deg = minf(rad_to_deg(asin(_sun_dir.y)), 60.0)
		_wait_until_usec = Time.get_ticks_usec() + 60_000_000
	else:
		_wait_until_usec = 0
		settings[_ttk_key()] = 5000.0
	await get_tree().create_timer(0.7).timeout
	var shot := get_viewport().get_texture().get_image()
	if "--crop" in args:
		# Centre of the screen at full resolution, for checking sight alignment.
		var size := Vector2i(900, 500)
		if "--zoom" in args:
			size = Vector2i(300, 166)
		shot = shot.get_region(Rect2i((shot.get_size() - size) / 2, size))
		if "--zoom" in args:
			shot.resize(900, 498, Image.INTERPOLATE_BILINEAR)
	shot.save_png(path)
	get_tree().quit()




func _build_gun() -> void:
	var built := Viewmodel.build(weapon)
	gun = built.root
	optic = built.optic
	muzzle_flash = built.flash
	_gun_hip_pos = built.hip
	_gun_irons_pos = built.irons
	_gun_optic_pos = built.optic_ads
	_gun_irons_pitch = built.irons_pitch
	_gun_mesh = built.gun_mesh
	_mount_surface = built.mount_surface
	_gun_hip_rot = built.hip_rotation
	_gun_tan_half_fov = tan(deg_to_rad(built.fov_vertical) / 2.0)
	# Stretching the weapon sideways and upward in camera space draws it exactly
	# as a camera with the weapon's own field of view would.
	_gun_lens = Node3D.new()
	camera.add_child(_gun_lens)
	_gun_lens.add_child(gun)
	_set_optic(settings.get("optic", true))


func _set_optic(on: bool) -> void:
	optic.visible = on
	Viewmodel.set_mount_visible(_gun_mesh, _mount_surface, on)


func _build_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)

	damage_overlay = ColorRect.new()
	damage_overlay.color = Color(0.8, 0.05, 0.05, 0.35)
	damage_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	damage_overlay.visible = false
	layer.add_child(damage_overlay)

	cue_left = ColorRect.new()
	cue_right = ColorRect.new()
	for bar: ColorRect in [cue_left, cue_right]:
		bar.color = Color(1.0, 0.25, 0.2, 0.6)
		bar.visible = false
		layer.add_child(bar)

	crosshair = ColorRect.new()
	crosshair.color = Color(1.0, 0.2, 0.15)
	crosshair.size = Vector2(4, 4)
	layer.add_child(crosshair)

	hit_marker = Label.new()
	hit_marker.text = "x"
	hit_marker.add_theme_font_size_override("font_size", 30)
	hit_marker.visible = false
	layer.add_child(hit_marker)

	status_label = Label.new()
	status_label.position = Vector2(24, 20)
	status_label.add_theme_font_size_override("font_size", 18)
	layer.add_child(status_label)

	result_label = Label.new()
	result_label.add_theme_font_size_override("font_size", 22)
	result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	layer.add_child(result_label)

	summary_label = Label.new()
	summary_label.add_theme_font_size_override("font_size", 24)
	summary_label.visible = false
	layer.add_child(summary_label)

	get_viewport().size_changed.connect(_layout_hud)
	_layout_hud()


func _layout_hud() -> void:
	var size := get_viewport().get_visible_rect().size
	damage_overlay.position = Vector2.ZERO
	damage_overlay.size = size
	cue_left.position = Vector2(0, size.y * 0.25)
	cue_left.size = Vector2(28, size.y * 0.5)
	cue_right.position = Vector2(size.x - 28, size.y * 0.25)
	cue_right.size = Vector2(28, size.y * 0.5)
	crosshair.position = size / 2.0 - crosshair.size / 2.0
	hit_marker.position = size / 2.0 + Vector2(14, -34)
	result_label.position = Vector2(0, size.y * 0.8)
	result_label.size = Vector2(size.x, 40)
	summary_label.position = Vector2(size.x * 0.28, size.y * 0.14)


func _open_log() -> void:
	var dir := ProjectSettings.globalize_path("user://telemetry")
	DirAccess.make_dir_recursive_absolute(dir)
	_log = FileAccess.open("%s/engagements_%d.csv" % [dir, int(Time.get_unix_time_from_system())],
		FileAccess.WRITE)
	if _log:
		_log.store_line("unix_time,drill,fov,sensitivity,dpi,enemy_ttk_ms,fight,fight_won," +
			"stack_index,zone,stance,offset_deg,visual_angle_deg,direction_deg,height_m," +
			"flick_deg,distance_m,in_view_at_spawn," +
			"pre_ads,react_ms,in_view_ms,ads_ms,first_shot_ms,first_hit_ms,kill_ms,shots,hits," +
			"headshots,first_shot_error_deg,sight")


# ---------- run flow ----------

func _start_run() -> void:
	_clear_targets()
	_run_recs.clear()
	_fights_done = 0
	_wins = 0
	_run_start_ttk = settings[_ttk_key()]
	summary_label.visible = false
	result_label.text = "%s. Hold right mouse to aim, hold left mouse to fire" % drill.goal
	_begin_wait(Time.get_ticks_usec())


func _begin_wait(now: int) -> void:
	state = State.WAITING
	_wait_until_usec = now + int(randf_range(0.8, 2.0) * 1e6)


func _begin_fight(now: int) -> void:
	_fight_recs.clear()
	_fight_ttk = settings[_ttk_key()]
	_first_rec = _spawn_target(now, 0)
	_stack_at_usec = 0
	if randf() < drill.stack_chance:
		_stack_at_usec = now + int(randf_range(0.3, 0.9) * 1e6)
	state = State.ACTIVE


func _weighted_pick(weights: Dictionary) -> String:
	var total := 0.0
	for key: String in weights:
		total += weights[key]
	var roll := randf() * total
	for key: String in weights:
		roll -= weights[key]
		if roll <= 0.0:
			return key
	return weights.keys()[0]


## Half the physical width and height of the screen, in centimetres.
func _screen_half_cm() -> Vector2:
	var aspect := get_viewport().get_visible_rect().size.aspect()
	var height: float = settings.monitor_diagonal_in * 2.54 / sqrt(1.0 + aspect * aspect)
	return Vector2(height * aspect, height) / 2.0


## How far to each side of the crosshair the screen reaches in the player's
## vision, in degrees of visual angle.
func _screen_visual_half_deg() -> Vector2:
	var half := _screen_half_cm()
	var d: float = settings.view_distance_cm
	return Vector2(rad_to_deg(atan(half.x / d)), rad_to_deg(atan(half.y / d)))


## Choose where a target should appear on screen for a visual-field zone, then
## work out where in the world that is for the current view (so it holds at any
## game FOV and while aiming down sights). Returns bearing, distance, base
## height, stance and the visual angle and direction actually used.
func _on_screen_spawn(zone: String, stance: String) -> Dictionary:
	var half := _screen_half_cm()
	var eye_cm: float = settings.view_distance_cm
	# Direction around the crosshair: mostly sideways, sometimes above or below.
	# Level targets stand on the ground; the others go on a ledge or close to your feet.
	var vertical: bool = randf() < drill.vertical_chance
	var phi := deg_to_rad(90.0 + randf_range(-30.0, 30.0)) if vertical else 0.0
	if randf() < 0.5:
		phi += PI
	var reach := minf(half.x * 0.93 / maxf(absf(cos(phi)), 1e-6),
		half.y * 0.9 / maxf(absf(sin(phi)), 1e-6))
	var ecc_max := rad_to_deg(atan(reach / eye_cm))
	var band: Array = VISUAL_ZONES[zone]
	var ecc := randf_range(minf(band[0], ecc_max * 0.85), minf(band[1], ecc_max))
	var r := eye_cm * tan(deg_to_rad(ecc))
	var screen := Vector2(r * cos(phi) / half.x, r * sin(phi) / half.y)

	var aspect := get_viewport().get_visible_rect().size.aspect()
	var tan_v := tan(deg_to_rad(Sens.horizontal_to_vertical_fov(_current_hfov(), 16.0 / 9.0)) / 2.0)
	var view := Basis.from_euler(aim.camera_rotation())
	var dir_cam := Vector3(screen.x * tan_v * aspect, screen.y * tan_v, -1.0).normalized()
	var dir := view * dir_cam
	var flat := maxf(Vector2(dir.x, dir.z).length(), 0.05)
	var distance := randf_range(MIN_DISTANCE, MAX_DISTANCE)
	var aim_h: float = Target.aim_height_for(stance)
	var bearing := rad_to_deg(atan2(dir.x, -dir.z))

	if not vertical:
		bearing = aim.yaw_deg + rad_to_deg(atan(screen.x * tan_v * aspect))
		dir.y = 0.0
	elif dir.y < 0.0:
		# Below eye level: stand the target on the ground where the sight line lands.
		var ground_d := (EYE.y - aim_h) / -dir.y * flat
		if ground_d < 4.0:
			dir.y = -dir.y  # too close to the feet; mirror it to above instead
		elif ground_d <= 60.0:
			distance = ground_d
	var base := 0.0
	if dir.y > 0.0:
		base = EYE.y + distance * dir.y / flat - aim_h
		if base >= 1.0 and stance == "prone":
			stance = "crouch"  # a prone target on a ledge would be hidden by the ledge
			base = EYE.y + distance * dir.y / flat - Target.aim_height_for(stance)
		# Only clearly raised targets get a platform; the rest stand on the ground.
		if base < 1.0:
			base = 0.0
	# Measure where the target really ended up in the player's vision.
	var b := deg_to_rad(bearing)
	var aim_point := Vector3(sin(b) * distance, base + Target.aim_height_for(stance),
		-cos(b) * distance)
	var cam := view.inverse() * (aim_point - EYE)
	var on_screen := Vector2(cam.x / -cam.z / (tan_v * aspect) * half.x,
		cam.y / -cam.z / tan_v * half.y)
	ecc = rad_to_deg(atan(on_screen.length() / eye_cm))
	return {
		"bearing": bearing, "distance": distance, "base": base, "stance": stance, "ecc": ecc,
		"direction": rad_to_deg(on_screen.angle()),
		"zone": _ecc_bin(ecc),
	}


func _ecc_bin(ecc: float) -> String:
	if ecc < 2.5:
		return "0-2.5"
	if ecc < 5.0:
		return "2.5-5"
	if ecc < 10.0:
		return "5-10"
	return "10-20" if ecc < 20.0 else "20+"


## Yaw offset for a zone outside the screen, measured against the current view.
func _off_screen_offset(zone: String) -> float:
	var half := _current_hfov() / 2.0
	var side := 1.0 if randf() < 0.5 else -1.0
	if zone == "behind":
		return side * randf_range(maxf(half + 60.0, 120.0), 180.0)
	return side * randf_range(half + 5.0, minf(half + 60.0, 175.0))


func _spawn_target(now: int, stack_index: int) -> Dictionary:
	var zone := _weighted_pick(drill.zones)
	var stance := _weighted_pick(drill.stances)
	var in_view := VISUAL_ZONES.has(zone)
	var place := {}
	if in_view:
		place = _on_screen_spawn(zone, stance)
	else:
		place = {
			"bearing": aim.yaw_deg + _off_screen_offset(zone), "base": 0.0, "stance": stance,
			"distance": randf_range(MIN_DISTANCE, MAX_DISTANCE), "ecc": -1.0,
			"direction": -1.0, "zone": zone,
		}
	var t: Node3D = Target.new()
	add_child(t)
	t.setup(place.stance, place.bearing, place.distance, profile.target_health,
		randf_range(profile.strafe_speed_min, profile.strafe_speed_max), place.base)
	var offset := wrapf(place.bearing - aim.yaw_deg, -180.0, 180.0)
	t.rec = {
		"t0": now, "stack_index": stack_index, "zone": place.zone, "stance": t.stance,
		"sight": "optic" if optic.visible else "irons",
		"offset": offset, "distance": t.distance, "in_view_at_spawn": in_view,
		"ecc": place.ecc, "direction": place.direction, "height": place.base,
		"flick_deg": rad_to_deg(aim.direction().angle_to((t.resting_aim_point() - EYE).normalized())),
		"pre_ads": Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT),
		"moved": 0.0, "react": -1.0, "in_view": 0.0 if in_view else -1.0, "ads": -1.0,
		"first_shot": -1.0, "first_hit": -1.0, "kill": -1.0,
		"shots": 0, "hits": 0, "headshots": 0, "first_shot_error": -1.0,
	}
	_targets.append(t)
	if not in_view:
		# Stand-in for a directional sound cue until audio is built.
		cue_left.visible = offset < 0.0
		cue_right.visible = offset > 0.0
		_cue_until_usec = now + 350_000
	return t.rec


func _ms_since(rec: Dictionary, now: int) -> float:
	return (now - int(rec.t0)) / 1000.0


func _remove_target(t: Node3D) -> void:
	_fight_recs.append(t.rec)
	_targets.erase(t)
	t.queue_free()


func _clear_targets() -> void:
	for t: Node3D in _targets.duplicate():
		_remove_target(t)


func _finish_fight(now: int, won: bool) -> void:
	_clear_targets()
	_stack_at_usec = 0
	_fights_done += 1
	_wins += int(won)
	settings[_ttk_key()] = clampf(_fight_ttk * (WIN_STEP if won else LOSS_STEP),
		MIN_ENEMY_TTK_MS, MAX_ENEMY_TTK_MS)
	if not won:
		damage_overlay.visible = true
		_overlay_until_usec = now + 250_000
	_fight_recs.sort_custom(func(a, b): return a.stack_index < b.stack_index)
	for rec: Dictionary in _fight_recs:
		rec["won"] = won
		_run_recs.append(rec)
		_write_log_row(rec, won)
	result_label.text = _result_text(won)
	if _fights_done >= RUN_LENGTH:
		_show_summary()
	else:
		_begin_wait(now)


func _result_text(won: bool) -> String:
	var parts := ["WON" if won else "LOST  (enemy took %d ms)" % _fight_ttk]
	for rec: Dictionary in _fight_recs:
		var bits := ["%s, %s:" % [ZONE_NAMES[rec.zone], rec.stance]]
		for pair in [["react", "moved"], ["first_hit", "first hit"], ["kill", "kill"]]:
			if rec[pair[0]] >= 0.0:
				bits.append("%s %d ms" % [pair[1], rec[pair[0]]])
		bits.append("%d/%d hits" % [rec.hits, rec.shots])
		parts.append(" ".join(bits))
	return "      ".join(parts)


func _write_log_row(rec: Dictionary, won: bool) -> void:
	if not _log:
		return
	_log.store_line(",".join([
		str(int(Time.get_unix_time_from_system())), drill_id, str(settings.fov),
		str(settings.sensitivity), str(settings.dpi), "%.0f" % _fight_ttk, str(_fights_done),
		str(int(won)), str(rec.stack_index), rec.zone, rec.stance, "%.1f" % rec.offset,
		"%.1f" % rec.ecc, "%.0f" % rec.direction, "%.1f" % rec.height, "%.1f" % rec.flick_deg,
		"%.1f" % rec.distance, str(int(rec.in_view_at_spawn)),
		str(int(rec.pre_ads)), "%.1f" % rec.react, "%.1f" % rec.in_view, "%.1f" % rec.ads,
		"%.1f" % rec.first_shot, "%.1f" % rec.first_hit, "%.1f" % rec.kill, str(rec.shots),
		str(rec.hits), str(rec.headshots), "%.2f" % rec.first_shot_error, rec.sight]))
	_log.flush()


func _show_summary() -> void:
	state = State.SUMMARY
	Config.save_settings(settings)
	var shots := 0
	var hits := 0
	var stage := {"react": [], "first_shot": [], "first_hit": [], "kill": []}
	var by_zone := {}
	var by_zone_react := {}
	var by_stance := {}
	var level := []
	var above_below := []
	for rec: Dictionary in _run_recs:
		shots += rec.shots
		hits += rec.hits
		for key: String in stage:
			if rec[key] >= 0.0:
				stage[key].append(rec[key])
		if rec.react >= 0.0:
			by_zone_react.get_or_add(rec.zone, []).append(rec.react)
			# The screen reaches only about 16 deg up and down, so compare
			# directions at matched distances from the crosshair.
			if rec.ecc >= 5.0 and rec.ecc <= 15.0:
				var steep := absf(sin(deg_to_rad(rec.direction))) > 0.7
				(above_below if steep else level).append(rec.react)
		if rec.first_hit >= 0.0:
			by_zone.get_or_add(rec.zone, []).append(rec.first_hit)
		if rec.kill >= 0.0:
			by_stance.get_or_add(rec.stance, []).append(rec.kill - rec.first_hit)
	var hit_rate := 100.0 * hits / maxi(shots, 1)
	var lines := [
		"%s: won %d of %d fights" % [drill.name, _wins, _fights_done],
		"",
		"Your level: beating an enemy who kills in %d ms" % settings[_ttk_key()],
		"(started this run at %d ms; lower is better)" % _run_start_ttk,
		"",
		"Typical time from the cue (median):",
		"   first mouse movement   %s" % _fmt_ms(Config.median(stage.react)),
		"   first shot             %s" % _fmt_ms(Config.median(stage.first_shot)),
		"   first hit              %s" % _fmt_ms(Config.median(stage.first_hit)),
		"   kill                   %s" % _fmt_ms(Config.median(stage.kill)),
		"Hit rate: %.0f%%" % hit_rate,
		"",
		"By distance from the crosshair in your vision:   noticed (first movement) / first hit",
	]
	for zone: String in ZONE_NAMES:
		if by_zone.has(zone) or by_zone_react.has(zone):
			lines.append("   %-18s %8s / %-8s (%d targets)" % [
				ZONE_NAMES[zone], _fmt_ms(Config.median(by_zone_react.get(zone, []))),
				_fmt_ms(Config.median(by_zone.get(zone, []))), by_zone.get(zone, []).size()])
	lines.append("")
	lines.append("Noticed, for targets 5 to 15 deg out:")
	lines.append("   %-18s %8s  (%d targets)" % [
		"to the side", _fmt_ms(Config.median(level)), level.size()])
	lines.append("   %-18s %8s  (%d targets)" % [
		"above or below", _fmt_ms(Config.median(above_below)), above_below.size()])
	lines.append("")
	lines.append("Time from first hit to kill, by stance:")
	for stance: String in Target.STANCES:
		if by_stance.has(stance):
			lines.append("   %-18s %s  (%d targets)" % [
				stance, _fmt_ms(Config.median(by_stance[stance])), by_stance[stance].size()])
	lines.append("")
	lines.append("Space = another run     1 / 2 / 3 = change drill     Esc = quit")
	summary_label.text = "\n".join(lines)
	summary_label.visible = true
	result_label.text = ""
	_append_history(hit_rate, stage)


func _fmt_ms(value: float) -> String:
	return "-" if is_nan(value) else "%d ms" % value


func _append_history(hit_rate: float, stage: Dictionary) -> void:
	var path := "user://history_v2.csv"
	var is_new := not FileAccess.file_exists(path)
	var f := FileAccess.open(path, FileAccess.WRITE if is_new else FileAccess.READ_WRITE)
	if not f:
		return
	if is_new:
		f.store_line("unix_time,drill,fov,sensitivity,dpi,fights,wins,enemy_ttk_start_ms," +
			"enemy_ttk_end_ms,median_react_ms,median_first_shot_ms,median_first_hit_ms," +
			"median_kill_ms,hit_rate_pct")
	f.seek_end()
	f.store_line("%d,%s,%s,%s,%s,%d,%d,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.1f" % [
		int(Time.get_unix_time_from_system()), drill_id, str(settings.fov),
		str(settings.sensitivity), str(settings.dpi), _fights_done, _wins, _run_start_ttk,
		settings[_ttk_key()], Config.median(stage.react), Config.median(stage.first_shot),
		Config.median(stage.first_hit), Config.median(stage.kill), hit_rate])


# ---------- input ----------

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			return
		var c: Vector2 = event.screen_relative
		aim.apply_counts(c.x, c.y)
		if state == State.ACTIVE and _first_rec.react < 0.0:
			_first_rec.moved += absf(c.x) + absf(c.y)
			if _first_rec.moved >= MOVE_THRESHOLD_COUNTS:
				_first_rec.react = _ms_since(_first_rec, Time.get_ticks_usec())
	elif event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			if state == State.ACTIVE and _first_rec.ads < 0.0:
				_first_rec.ads = _ms_since(_first_rec, Time.get_ticks_usec())
	elif event is InputEventKey and event.pressed and not event.echo:
		var step := 0.5 if event.shift_pressed else 0.05
		match event.keycode:
			KEY_ESCAPE:
				Config.save_settings(settings)
				get_tree().quit()
			KEY_SPACE:
				if state == State.SUMMARY:
					_start_run()
			KEY_1:
				_load_drill(DRILLS[0])
			KEY_2:
				_load_drill(DRILLS[1])
			KEY_3:
				_load_drill(DRILLS[2])
			KEY_T:
				_set_optic(not optic.visible)
				settings["optic"] = optic.visible
				Config.save_settings(settings)
			KEY_F1:
				_change("monitor_diagonal_in", clampf(settings.monitor_diagonal_in - 1.0, 13.0, 65.0))
			KEY_F2:
				_change("monitor_diagonal_in", clampf(settings.monitor_diagonal_in + 1.0, 13.0, 65.0))
			KEY_F3:
				_change("view_distance_cm", clampf(settings.view_distance_cm - 5.0, 30.0, 150.0))
			KEY_F4:
				_change("view_distance_cm", clampf(settings.view_distance_cm + 5.0, 30.0, 150.0))
			KEY_BRACKETLEFT:
				_change("sensitivity", clampf(snappedf(settings.sensitivity - step, 0.01), 0.01, 100.0))
			KEY_BRACKETRIGHT:
				_change("sensitivity", clampf(snappedf(settings.sensitivity + step, 0.01), 0.01, 100.0))
			KEY_COMMA:
				_change("fov", clampf(settings.fov - 5.0, 60.0, 120.0))
			KEY_PERIOD:
				_change("fov", clampf(settings.fov + 5.0, 60.0, 120.0))


func _change(key: String, value: float) -> void:
	settings[key] = value
	_apply_settings()
	Config.save_settings(settings)


# ---------- per frame ----------

func _process(delta: float) -> void:
	var now := Time.get_ticks_usec()
	_update_ads(delta)
	_update_fire(now)

	if state == State.WAITING and now >= _wait_until_usec:
		_begin_fight(now)
	elif state == State.ACTIVE:
		_update_fight(now, delta)

	camera.rotation = aim.camera_rotation()
	camera.fov = Sens.horizontal_to_vertical_fov(_current_hfov(), 16.0 / 9.0)
	_update_gun_pose(delta)
	# With iron sights the front post is the aiming mark, so the dot goes away.
	crosshair.visible = optic.visible or _ads_progress < 0.6
	muzzle_flash.visible = now < _flash_until_usec
	hit_marker.visible = now < _marker_until_usec
	damage_overlay.visible = now < _overlay_until_usec
	if now >= _cue_until_usec:
		cue_left.visible = false
		cue_right.visible = false
	status_label.text = _status_text()


## Place the weapon between hip and the chosen sight, then add recoil kick
## and a little lag behind the mouse. Both shrink while aiming so the sight
## stays close to the true aim point.
func _update_gun_pose(delta: float) -> void:
	var ads_pos := _gun_optic_pos if optic.visible else _gun_irons_pos
	var aimed := _ease(_ads_progress)
	var loose := lerpf(1.0, 0.25, aimed)

	_kick = maxf(_kick - _kick * KICK_DECAY_PER_S * delta, 0.0)
	var turn := Vector2(aim.yaw_deg - _last_yaw, aim.pitch_deg - _last_pitch)
	_last_yaw = aim.yaw_deg
	_last_pitch = aim.pitch_deg
	var want := (Vector2(-turn.x, turn.y) * SWAY_M_PER_DEG / maxf(delta, 0.001) * 0.05).limit_length(SWAY_MAX_M)
	_sway = _sway.lerp(want, minf(delta * 10.0, 1.0))

	# Iron sights need the gun tipped up a touch, about the eye, so the front
	# post sits on the aim point.
	var tilt := 0.0 if optic.visible else _gun_irons_pitch
	var aimed_pos := Basis(Vector3.RIGHT, deg_to_rad(tilt)) * ads_pos
	gun.position = _gun_hip_pos.lerp(aimed_pos, aimed) \
		+ Vector3(_sway.x, _sway.y, _kick * KICK_BACK_M) * loose
	gun.rotation_degrees = _gun_hip_rot.lerp(Vector3(tilt, 0, 0), aimed) \
		+ Vector3(_kick * KICK_UP_DEG * loose, 0, 0)
	var lens := tan(deg_to_rad(camera.fov) / 2.0) / _gun_tan_half_fov
	_gun_lens.scale = Vector3(lens, lens, 1.0)


func _update_fight(now: int, delta: float) -> void:
	if _stack_at_usec > 0 and now >= _stack_at_usec:
		_stack_at_usec = 0
		_spawn_target(now, 1)
	var half := _current_hfov() / 2.0
	for t: Node3D in _targets:
		t.update(delta)
		if t.rec.in_view < 0.0 and absf(wrapf(t.bearing - aim.yaw_deg, -180.0, 180.0)) < half:
			t.rec.in_view = _ms_since(t.rec, now)
		if _ms_since(t.rec, now) > _fight_ttk:
			_finish_fight(now, false)
			return
	if _targets.is_empty() and _stack_at_usec == 0:
		_finish_fight(now, true)


func _ease(t: float) -> float:
	return t * t * (3.0 - 2.0 * t)


func _current_hfov() -> float:
	return lerpf(_hip_hfov, _ads_hfov, _ease(_ads_progress))


func _update_ads(delta: float) -> void:
	var step: float = delta * 1000.0 / weapon.ads_time_ms
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) or _force_ads) and state != State.SUMMARY:
		_ads_progress = minf(_ads_progress + step, 1.0)
	else:
		_ads_progress = maxf(_ads_progress - step, 0.0)
	aim.deg_per_count = _base_deg_per_count * lerpf(1.0, _ads_multiplier, _ads_progress)


func _update_fire(now: int) -> void:
	if state == State.SUMMARY or not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	if now < _next_shot_usec:
		return
	_next_shot_usec = now + int(60.0e6 / weapon.rpm)
	_fire(now)


func _fire(now: int) -> void:
	# Bullets go where the sight points only once it is fully raised.
	var spread: float = weapon.hip_spread_deg * (1.0 - _ads_progress)
	var r := spread * sqrt(randf())
	var theta := randf() * TAU
	var dir := aim.direction(r * cos(theta), r * sin(theta))
	_flash_until_usec = now + 35_000
	_kick = minf(_kick + 1.0, 1.6)

	if state == State.ACTIVE and not _targets.is_empty():
		# The shot counts against whichever target the sight is closest to.
		var view := aim.direction()
		var aimed_at: Node3D = null
		var best_angle := INF
		var struck: Node3D = null
		var struck_kind := Geo.MISS
		for t: Node3D in _targets:
			var angle := view.angle_to((t.aim_point() - EYE).normalized())
			if angle < best_angle:
				best_angle = angle
				aimed_at = t
			var kind: int = t.hit_test(EYE, dir)
			if kind != Geo.MISS and (struck == null or t.distance < struck.distance):
				struck = t
				struck_kind = kind
		var rec: Dictionary = aimed_at.rec
		rec.shots += 1
		if rec.first_shot < 0.0:
			rec.first_shot = _ms_since(rec, now)
			rec.first_shot_error = rad_to_deg(best_angle)
		aimed_at.shot_at()
		if struck != null:
			_apply_hit(struck, struck_kind, now)

	aim.add_degrees(randf_range(-1.0, 1.0) * weapon.recoil_yaw_deg, weapon.recoil_pitch_deg)


func _apply_hit(t: Node3D, kind: int, now: int) -> void:
	var rec: Dictionary = t.rec
	rec.hits += 1
	if rec.first_hit < 0.0:
		rec.first_hit = _ms_since(rec, now)
	var damage: float = weapon.damage
	if kind == Geo.HEAD:
		rec.headshots += 1
		damage *= weapon.headshot_multiplier
	t.health -= damage
	_marker_until_usec = now + 80_000
	if t.health <= 0.0:
		rec.kill = _ms_since(rec, now)
		_remove_target(t)


func _status_text() -> String:
	var lines := [
		"%s  [1 / 2 / 3]    fight %d of %d" % [
			drill.name, mini(_fights_done + 1, RUN_LENGTH), RUN_LENGTH],
		"Enemy kills in %d ms" % settings[_ttk_key()],
		"FOV %d  [, / .]    targets look %d%% the size they do at 90" % [
			settings.fov, 100.0 * Sens.on_screen_scale(settings.fov, 90.0)],
		"Sensitivity %.2f  [ [ / ] ]    %.1f cm/360" % [
			settings.sensitivity,
			Sens.cm_per_360(settings.dpi, profile.yaw_constant, settings.sensitivity)],
		"Monitor %d in [F1 / F2] at %d cm [F3 / F4]: screen covers %d deg each side of your vision, %d up and down" % [
			settings.monitor_diagonal_in, settings.view_distance_cm,
			_screen_visual_half_deg().x, _screen_visual_half_deg().y],
		"%s  (placeholder values)    sight: %s  [T]" % [
			weapon.name, "red dot" if optic.visible else "iron sights"],
	]
	return "\n".join(lines)
