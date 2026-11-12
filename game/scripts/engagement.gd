extends Node3D
## Engagement drill. Each fight starts at an unpredictable moment with a
## target placed relative to what the player can currently see (centre, mid,
## edge of screen, just off screen, or behind), in a random stance. A second
## target may stack in while the first is still alive. Turn, raise the sight,
## hold fire through recoil. Every stage is timed from each target's cue.
##
## An enemy "kills you" if it stays alive longer than its time-to-kill; that
## time adapts per drill so you win about 70% of fights, and is your level.
##
## This file is the drill's flow: fights, input, aiming and firing. The parts
## it drives live beside it: placement.gd (where targets appear),
## weapon_view.gd (the gun on screen), hud.gd (text and markers),
## summary.gd (results) and run_log.gd (files).

const Sens = preload("res://scripts/sens.gd")
const AimState = preload("res://scripts/aim_state.gd")
const Config = preload("res://scripts/config.gd")
const Geo = preload("res://scripts/target_geometry.gd")
const Target = preload("res://scripts/target.gd")
const Lighting = preload("res://scripts/lighting.gd")
const Placement = preload("res://scripts/placement.gd")
const WeaponView = preload("res://scripts/weapon_view.gd")
const Hud = preload("res://scripts/hud.gd")
const Summary = preload("res://scripts/summary.gd")
const RunLog = preload("res://scripts/run_log.gd")

enum State { WAITING, ACTIVE, SUMMARY }

const DRILLS := ["mixed", "peripheral", "offscreen"]
const RUN_LENGTH := 20
const EYE := Vector3(0, 1.7, 0)
const MOVE_THRESHOLD_COUNTS := 4.0
# Nobody reacts to something seen in under a tenth of a second; movement
# before that was already under way when the target appeared.
const MIN_REACTION_MS := 100.0
# Share of the distance to the target an unbroken movement toward it must
# cover before it counts as the reaction.
const REACTION_RUN_SHARE := 0.1
# One-up one-down staircase; step ratio 7:3 settles near a 70% win rate.
const WIN_STEP := 0.97
const LOSS_STEP := 1.07
const MIN_ENEMY_TTK_MS := 300.0
const MAX_ENEMY_TTK_MS := 5000.0
# Session check: a fixed test, the same every session, that practice is
# measured against. Nothing adapts and nothing shoots back.
const CHECK_TIMEOUT_MS := 4000.0
const CHECK_SEED := 20261112

var profile := {}
var weapon := {}
var settings := {}
var drill := {}
var drill_id := "mixed"
var aim := AimState.new()
var state := State.WAITING

var camera: Camera3D
var weapon_view: WeaponView
var hud: Hud
var run_log := RunLog.new()

var _sun_dir := Vector3.UP
var _base_deg_per_count := 0.0
var _ads_progress := 0.0
var _ads_multiplier := 1.0
var _hip_hfov := 110.0
var _ads_hfov := 90.0
var _force_ads := false
var _next_shot_usec := 0
var _wait_until_usec := 0

var _targets: Array = []
var _fight_recs: Array = []
var _first_rec := {}
var _first_target: Node3D
var _react_run_start := 0.0
var _stack_at_usec := 0
var _fight_ttk := 0.0
var _fights_done := 0
var _wins := 0
var _run_recs: Array = []
var _run_start_ttk := 0.0
var _check := false
var _check_cold := true


func _ready() -> void:
	profile = Config.load_json("res://profiles/call_of_duty.json")
	weapon = Config.load_json("res://weapons/mp5.json")
	settings = Config.load_settings()
	_detect_monitor(false)
	Input.use_accumulated_input = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_build_world()
	weapon_view = WeaponView.new()
	camera.add_child(weapon_view)
	weapon_view.setup(weapon, settings.get("optic", true))
	hud = Hud.new()
	add_child(hud)
	_apply_settings()
	run_log.open()
	var args := OS.get_cmdline_user_args()
	var dev := "--no-check" in args
	for arg: String in args:
		dev = dev or arg.begins_with("--screenshot=")
	if dev:
		_load_drill(settings.get("drill", "mixed"))
	else:
		_start_check()
	_screenshot_if_requested()


# ---------- setup ----------

func _apply_settings() -> void:
	_base_deg_per_count = Sens.degrees_per_count(profile.yaw_constant, settings.sensitivity)
	_hip_hfov = settings.fov
	_ads_hfov = Sens.zoomed_fov(_hip_hfov, weapon.zoom)
	_ads_multiplier = Sens.relative_ads_multiplier(
		Sens.horizontal_to_vertical_fov(_hip_hfov, Placement.FOV_ASPECT),
		Sens.horizontal_to_vertical_fov(_ads_hfov, Placement.FOV_ASPECT),
		profile.ads_monitor_coefficient)


func _load_drill(id: String) -> void:
	_check = false
	drill_id = id if id in DRILLS else "mixed"
	drill = Config.load_json("res://drills/%s.json" % drill_id)
	settings["drill"] = drill_id
	if not settings.has(_ttk_key()):
		settings[_ttk_key()] = float(drill.start_enemy_ttk_ms)
	Config.save_settings(settings)
	_start_run()


func _start_check() -> void:
	_check = true
	var saved: String = settings.get("drill", "mixed")
	drill_id = saved if saved in DRILLS else "mixed"
	drill = Config.load_json("res://drills/check.json")
	_start_run()


func _run_length() -> int:
	return drill.sequence.size() if _check else RUN_LENGTH


## True while a check is being taken; settings that would make it
## incomparable with other checks are locked until it ends.
func _check_running() -> bool:
	return _check and state != State.SUMMARY


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


func _flat_material(color: Color) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.9
	return mat


## Development aid: "-- --screenshot=<path>" saves one frame and quits. Add
## "--ads" to raise the sight, "--irons" to remove the optic, "--look-sun" to
## face the sun and check the shadows agree with the sky, and "--crop"
## (optionally with "--zoom") for the centre of the screen.
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
		weapon_view.set_optic(false)
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


# ---------- run flow ----------

func _start_run() -> void:
	_clear_targets()
	_run_recs.clear()
	_fights_done = 0
	_wins = 0
	_run_start_ttk = settings.get(_ttk_key(), 0.0)
	hud.hide_summary()
	hud.set_result("%s. Hold right mouse to aim, hold left mouse to fire" % drill.goal)
	_begin_wait(Time.get_ticks_usec())


func _begin_wait(now: int) -> void:
	state = State.WAITING
	_wait_until_usec = now + int(randf_range(0.8, 2.0) * 1e6)


func _begin_fight(now: int) -> void:
	_fight_recs.clear()
	_fight_ttk = CHECK_TIMEOUT_MS if _check else float(settings[_ttk_key()])
	_first_rec = _spawn_target(now, 0)
	_first_target = _targets.back()
	_stack_at_usec = 0
	if not _check and randf() < drill.stack_chance:
		_stack_at_usec = now + int(randf_range(0.3, 0.9) * 1e6)
	state = State.ACTIVE


func _aspect() -> float:
	return get_viewport().get_visible_rect().size.aspect()


func _spawn_target(now: int, stack_index: int) -> Dictionary:
	var spec := drill
	if _check:
		# Target number N is the same kind of target, in the same place
		# relative to the crosshair, in every check.
		var step: Array = drill.sequence[_fights_done]
		spec = {"zones": {step[0]: 1}, "stances": {step[1]: 1},
			"vertical_chance": 1.0 if step[2] else 0.0}
		seed(CHECK_SEED + _fights_done)
	var place := Placement.place(spec, settings, aim, _current_hfov(), _aspect(), EYE)
	var t: Node3D = Target.new()
	add_child(t)
	t.setup(place.stance, place.bearing, place.distance, profile.target_health,
		randf_range(profile.strafe_speed_min, profile.strafe_speed_max), place.base)
	if _check:
		randomize()
	var offset := wrapf(place.bearing - aim.yaw_deg, -180.0, 180.0)
	t.rec = {
		"t0": now, "stack_index": stack_index, "zone": place.zone, "stance": t.stance,
		"sight": weapon_view.sight_name(),
		"offset": offset, "distance": t.distance, "in_view_at_spawn": place.in_view,
		"ecc": place.ecc, "direction": place.direction, "height": place.base,
		"flick_deg": rad_to_deg(aim.direction().angle_to((t.resting_aim_point() - EYE).normalized())),
		"pre_ads": Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT),
		"moved": 0.0, "react": -1.0, "in_view": 0.0 if place.in_view else -1.0, "ads": -1.0,
		"first_shot": -1.0, "first_hit": -1.0, "kill": -1.0,
		"shots": 0, "hits": 0, "headshots": 0, "first_shot_error": -1.0,
	}
	_targets.append(t)
	if not place.in_view:
		# Stand-in for a directional sound cue until audio is built.
		hud.cue(offset, now)
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
	if not _check:
		settings[_ttk_key()] = clampf(_fight_ttk * (WIN_STEP if won else LOSS_STEP),
			MIN_ENEMY_TTK_MS, MAX_ENEMY_TTK_MS)
		if not won:
			hud.damage(now)
	_fight_recs.sort_custom(func(a, b): return a.stack_index < b.stack_index)
	for rec: Dictionary in _fight_recs:
		rec["won"] = won
		_run_recs.append(rec)
		run_log.write_target(rec, won, "check" if _check else drill_id, settings, _fight_ttk,
			_fights_done)
	var headline := ""
	if _check:
		headline = "KILLED" if won else "OUT OF TIME"
	hud.set_result(Summary.fight_text(won, _fight_ttk, _fight_recs, headline))
	if _fights_done >= _run_length():
		_show_summary()
	else:
		_begin_wait(now)


func _show_summary() -> void:
	state = State.SUMMARY
	Config.save_settings(settings)
	if _check:
		var version := int(drill.version)
		var sight := weapon_view.sight_name()
		var result := Summary.check_result(_run_recs, CHECK_TIMEOUT_MS)
		var earlier := RunLog.earlier_checks(RunLog.read_checks_file(), version, sight,
			settings.fov)
		RunLog.append_check(version, _check_cold, sight, settings, result)
		hud.show_summary(Summary.check_text(result, earlier,
			"the red dot" if weapon_view.has_optic() else "iron sights", settings.fov,
			CHECK_TIMEOUT_MS, _check_cold))
		_check_cold = false
		return
	var stats := Summary.stats(_run_recs)
	var run_sight := weapon_view.sight_name()
	var earlier_runs := RunLog.earlier_runs(RunLog.read_history_file(), drill_id, run_sight,
		settings.fov)
	hud.show_summary(Summary.run_text(stats, drill.name, _wins, _fights_done,
		settings[_ttk_key()], _run_start_ttk, earlier_runs, "%s at FOV %d" % [
			"the red dot" if weapon_view.has_optic() else "iron sights", settings.fov]))
	RunLog.append_history(drill_id, run_sight, settings, _fights_done, _wins, _run_start_ttk,
		settings[_ttk_key()], stats)


# ---------- input ----------

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			return
		var c: Vector2 = event.screen_relative
		aim.apply_counts(c.x, c.y)
		if state == State.ACTIVE and _first_rec.react < 0.0 and is_instance_valid(_first_target):
			# Reaction = the first movement toward the target, not just any movement.
			var since := _ms_since(_first_rec, Time.get_ticks_usec())
			if since >= MIN_REACTION_MS:
				var to: Vector3 = (_first_target.aim_point() - EYE).normalized()
				var yaw_to := wrapf(rad_to_deg(atan2(to.x, -to.z)) - aim.yaw_deg, -180.0, 180.0)
				var pitch_to := rad_to_deg(asin(clampf(to.y, -1.0, 1.0))) - aim.pitch_deg
				var toward := AimState.counts_toward(c.x, c.y, yaw_to, pitch_to)
				# The hand is rarely still (scanning), so one count toward the
				# target proves nothing. Look for an unbroken run toward it that
				# covers a real part of the distance, and time it from its start.
				if toward <= 0.0:
					_first_rec.moved = 0.0
				else:
					if _first_rec.moved == 0.0:
						_react_run_start = since
					_first_rec.moved += toward
					var needed := maxf(MOVE_THRESHOLD_COUNTS,
						REACTION_RUN_SHARE * _first_rec.flick_deg / aim.deg_per_count)
					if _first_rec.moved >= needed:
						_first_rec.react = _react_run_start
	elif event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			if state == State.ACTIVE and _first_rec.ads < 0.0:
				_first_rec.ads = _ms_since(_first_rec, Time.get_ticks_usec())
	elif event is InputEventKey and event.pressed and not event.echo:
		var step := 0.5 if event.shift_pressed else 0.05
		if _check_running() and event.keycode in [KEY_C, KEY_T, KEY_BRACKETLEFT,
				KEY_BRACKETRIGHT, KEY_COMMA, KEY_PERIOD, KEY_F1, KEY_F2, KEY_F3, KEY_F4, KEY_F5]:
			return
		match event.keycode:
			KEY_ESCAPE:
				Config.save_settings(settings)
				get_tree().quit()
			KEY_SPACE:
				if state == State.SUMMARY:
					if _check:
						_load_drill(settings.get("drill", "mixed"))
					else:
						_start_run()
			KEY_C:
				_start_check()
			KEY_1:
				_load_drill(DRILLS[0])
			KEY_2:
				_load_drill(DRILLS[1])
			KEY_3:
				_load_drill(DRILLS[2])
			KEY_T:
				weapon_view.set_optic(not weapon_view.has_optic())
				settings["optic"] = weapon_view.has_optic()
				Config.save_settings(settings)
			KEY_F1:
				settings["monitor_manual"] = true
				_change("monitor_diagonal_in", clampf(roundf(settings.monitor_diagonal_in) - 1.0, 13.0, 65.0))
			KEY_F2:
				settings["monitor_manual"] = true
				_change("monitor_diagonal_in", clampf(roundf(settings.monitor_diagonal_in) + 1.0, 13.0, 65.0))
			KEY_F5:
				_detect_monitor(true)
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
	camera.fov = Sens.horizontal_to_vertical_fov(_current_hfov(), Placement.FOV_ASPECT)
	weapon_view.update(delta, now, aim, _ease(_ads_progress), camera.fov)
	# With iron sights the front post is the aiming mark, so the dot goes away.
	hud.update(now, weapon_view.has_optic() or _ads_progress < 0.6)
	hud.set_status(_status_text())


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
	weapon_view.fired(now)

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
	hud.hit(now)
	if t.health <= 0.0:
		rec.kill = _ms_since(rec, now)
		_remove_target(t)


func _status_text() -> String:
	var reach := Placement.screen_visual_half_deg(settings.monitor_diagonal_in,
		settings.view_distance_cm, _aspect())
	var lines := [
		"%s  [1 / 2 / 3]    fight %d of %d" % [
			drill.name, mini(_fights_done + 1, RUN_LENGTH), RUN_LENGTH],
		"Enemy kills in %d ms" % settings[_ttk_key()],
	]
	if _check:
		lines = [
			"Session check    target %d of %d    [1 / 2 / 3 = skip to practice]" % [
				mini(_fights_done + 1, _run_length()), _run_length()],
			"Settings are locked until the check ends",
		]
	lines += [
		"FOV %d  [, / .]    targets look %d%% the size they do at 90" % [
			settings.fov, 100.0 * Sens.on_screen_scale(settings.fov, 90.0)],
		"Sensitivity %.2f  [ [ / ] ]    %.1f cm/360" % [
			settings.sensitivity,
			Sens.cm_per_360(settings.dpi, profile.yaw_constant, settings.sensitivity)],
		"Monitor %.0f in (%s) [F1 / F2, F5 = detect] at %d cm [F3 / F4]: screen covers %d deg each side of your vision, %d up and down" % [
			settings.monitor_diagonal_in,
			"set by hand" if settings.get("monitor_manual", false) else "detected" if settings.get("monitor_detected_for", "") != "" else "default, not detected",
			settings.view_distance_cm, reach.x, reach.y],
		"%s  (placeholder values)    sight: %s  [T]" % [
			weapon.name, "red dot" if weapon_view.has_optic() else "iron sights"],
	]
	return "\n".join(lines)


## Use the size the monitor reports about itself, so nobody has to type it
## in. Asked once per screen resolution (the query takes about a second);
## `force` asks again and drops a size set by hand.
func _detect_monitor(force: bool) -> void:
	var screen := str(DisplayServer.screen_get_size())
	if not force and (settings.get("monitor_manual", false)
			or settings.get("monitor_detected_for", "") == screen):
		return
	var diagonal: float = Config.detect_monitor_diagonal_in()
	if diagonal <= 0.0:
		return
	settings["monitor_diagonal_in"] = diagonal
	settings["monitor_manual"] = false
	settings["monitor_detected_for"] = screen
	Config.save_settings(settings)
