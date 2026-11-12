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
## Nothing is shown on screen during play except what a game would show.
## A briefing comes before each run and the numbers come after it.
##
## This file is the drill's flow: fights, input, aiming and firing. The parts
## it drives live beside it: placement.gd (where targets appear),
## weapon_view.gd (the gun on screen), hud.gd (crosshair and panels),
## summary.gd (results) and run_log.gd (files). app.gd starts it from the
## menu: set `mode` before adding it to the tree.

const Sens = preload("res://scripts/sens.gd")
const AimState = preload("res://scripts/aim_state.gd")
const Config = preload("res://scripts/config.gd")
const Geo = preload("res://scripts/target_geometry.gd")
const Target = preload("res://scripts/target.gd")
const World = preload("res://scripts/world.gd")
const Cover = preload("res://scripts/cover.gd")
const GunAudio = preload("res://scripts/gun_audio.gd")
const Placement = preload("res://scripts/placement.gd")
const WeaponView = preload("res://scripts/weapon_view.gd")
const Hud = preload("res://scripts/hud.gd")
const Summary = preload("res://scripts/summary.gd")
const RunLog = preload("res://scripts/run_log.gd")

## Emitted when the player leaves for the menu.
signal exit_to_menu

enum State { BRIEFING, WAITING, ACTIVE, SUMMARY }

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
# How long after coming into sight an enemy starts shooting back.
const ENEMY_FIRE_DELAY_USEC := 250_000
# Walking speed of an enemy stepping out from behind cover, in m/s.
const PEEK_SPEED := 2.2

## What to run: "check" for the session check (followed by practice), or a
## drill id. Set by the menu before this node enters the tree.
var mode := "check"
## Development aid, set by app.gd: jump straight to "play", "results" or
## "pause" so that screen can be photographed.
var dev_show := ""

var profile := {}
var weapon := {}
var settings := {}
var drill := {}
var drill_id := "mixed"
var aim := AimState.new()
var state := State.BRIEFING

var camera: Camera3D
var weapon_view: WeaponView
var hud: Hud
var audio: GunAudio
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
var _paused := false

var _cover: Array = Cover.layout()
var _cover_node: Node3D
## Seed of the arena in use; 0 is the fixed layout the session check uses.
var _arena_seed := 0
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
	Input.use_accumulated_input = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_sun_dir = World.build(self)
	camera = Camera3D.new()
	camera.position = EYE
	camera.keep_aspect = Camera3D.KEEP_HEIGHT
	camera.near = 0.03
	add_child(camera)
	camera.make_current()
	weapon_view = WeaponView.new()
	camera.add_child(weapon_view)
	weapon_view.setup(weapon, settings.get("optic", true))
	hud = Hud.new()
	add_child(hud)
	hud.resume_pressed.connect(_resume)
	hud.quit_pressed.connect(_leave)
	audio = GunAudio.new()
	add_child(audio)
	_apply_settings()
	if dev_show == "":
		run_log.open()
	if mode == "check":
		_start_check()
	else:
		_load_drill(mode)
	match dev_show:
		"":
			_screenshot_if_requested()
		"play", "cover":
			_begin_run(Time.get_ticks_usec())
			_wait_until_usec = 0
		"results":
			_show_summary()
		"pause":
			_begin_run(Time.get_ticks_usec())
			_pause()


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


func _ttk_key() -> String:
	return "enemy_ttk_ms_" + drill_id


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
	_begin_run(Time.get_ticks_usec())
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

## Practice gets a new arena every run, so the layout itself cannot be
## learned. The session check always uses the same fixed one, or its
## results would not be comparable from day to day.
func _new_arena() -> void:
	_arena_seed = 0 if _check else maxi(randi(), 1)
	if dev_show == "cover":
		for arg: String in OS.get_cmdline_user_args():
			if arg.begins_with("--arena="):
				_arena_seed = int(arg.trim_prefix("--arena="))
	_cover = Cover.layout() if _arena_seed == 0 else Cover.generate(_arena_seed)
	if _cover_node:
		_cover_node.queue_free()
	_cover_node = World.build_cover(self, _cover)


func _start_run() -> void:
	_clear_targets()
	_new_arena()
	_fight_recs.clear()
	_run_recs.clear()
	_fights_done = 0
	_wins = 0
	_run_start_ttk = settings.get(_ttk_key(), 0.0)
	state = State.BRIEFING
	var lines := [drill.goal + "."]
	if _check:
		lines.append("Each target has a %d second limit. Your result is saved and compared with earlier checks." % (
			CHECK_TIMEOUT_MS / 1000.0))
	else:
		lines.append("An enemy left alive too long kills you. That time shortens as you win and lengthens as you lose. %d fights." % RUN_LENGTH)
	lines.append("Hold right mouse to aim, hold left mouse to fire.")
	hud.show_briefing(drill.name, lines, [["CLICK", "BEGIN"], ["ESC", "MENU"]])


func _begin_run(now: int) -> void:
	hud.hide_panel()
	# The click that starts the run should not also fire the gun.
	_next_shot_usec = now + 400_000
	_begin_wait(now)


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
	# Some enemies are already there, behind cover, and step out. The check
	# never uses them: its targets always appear in the open.
	var peek := {}
	if not _check and randf() < float(drill.get("cover_chance", 0.0)):
		peek = _pick_peek()
	var t: Node3D = Target.new()
	add_child(t)
	var strafe := randf_range(profile.strafe_speed_min, profile.strafe_speed_max)
	var place := {}
	if peek.is_empty():
		place = _open_place(spec)
		t.setup(place.stance, place.bearing, place.distance, profile.target_health, strafe,
			place.base)
	else:
		var piece: Dictionary = peek.piece
		t.setup(Placement.weighted_pick(drill.stances), piece.bearing, peek.spot.distance,
			profile.target_health, strafe)
		t.setup_peek(piece.bearing, peek.side, peek.spot, PEEK_SPEED)
	if _check:
		randomize()
	t.rec = {
		"t0": now, "stack_index": stack_index, "zone": "", "stance": t.stance,
		"sight": weapon_view.sight_name(), "from_cover": t.from_cover(),
		"arena_seed": _arena_seed,
		"offset": 0.0, "distance": t.distance, "in_view_at_spawn": false,
		"ecc": -1.0, "direction": -1.0, "height": t.base_height, "flick_deg": 0.0,
		"pre_ads": false,
		"moved": 0.0, "react": -1.0, "in_view": -1.0, "ads": -1.0,
		"first_shot": -1.0, "first_hit": -1.0, "kill": -1.0,
		"shots": 0, "hits": 0, "headshots": 0, "first_shot_error": -1.0,
	}
	_targets.append(t)
	if peek.is_empty():
		_mark_seen(t, now, place)
	return t.rec


## The moment a target comes into sight: its clock starts and where it is
## in the player's vision is recorded. `where` is what placement reported
## for a target put in the open; one stepping out of cover is measured here.
func _mark_seen(t: Node3D, now: int, where := {}) -> void:
	if where.is_empty():
		where = Placement.measure(t.resting_aim_point(), settings, aim, _current_hfov(),
			_aspect(), EYE)
	var rec: Dictionary = t.rec
	t.seen = true
	t.next_fire_usec = now + ENEMY_FIRE_DELAY_USEC
	rec.t0 = now
	rec.zone = where.zone
	rec.ecc = where.ecc
	rec.direction = where.direction
	rec.in_view_at_spawn = where.in_view
	rec.in_view = 0.0 if where.in_view else -1.0
	rec.offset = wrapf(t.bearing - aim.yaw_deg, -180.0, 180.0)
	rec.flick_deg = rad_to_deg(aim.direction().angle_to((t.resting_aim_point() - EYE).normalized()))
	rec.pre_ads = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
	if not where.in_view:
		# Stand-in for a directional sound cue until audio is built.
		hud.cue(rec.offset, now)


## Place a target in the open where the player can see it: not inside a
## piece of cover and not hidden behind one.
func _open_place(spec: Dictionary) -> Dictionary:
	var place := {}
	for attempt in 12:
		place = Placement.place(spec, settings, aim, _current_hfov(), _aspect(), EYE)
		var b := deg_to_rad(place.bearing)
		var feet := Vector3(sin(b), 0.0, -cos(b)) * float(place.distance)
		var chest := feet + Vector3(0.0,
			place.base + Target.aim_height_for(place.stance), 0.0)
		if not Cover.inside(_cover, feet, 0.7) and not Cover.blocked(_cover, EYE, chest):
			break
	return place


## Choose a piece of cover and a side for an enemy to step out from, so
## that it appears in a part of the player's vision the drill asks for.
## Returns {} if no cover is in such a place right now.
func _pick_peek() -> Dictionary:
	var zone := Placement.weighted_pick(drill.zones)
	var options := []
	for piece: Dictionary in _cover:
		if not piece.tall or _cover_in_use(piece):
			continue
		for side: float in [-1.0, 1.0]:
			var spot := Cover.peek(piece, side)
			var b := deg_to_rad(piece.bearing + side * float(spot.min_off))
			var chest := Vector3(sin(b) * spot.distance, Target.aim_height_for("stand"),
				-cos(b) * spot.distance)
			var seen_at := Placement.measure(chest, settings, aim, _current_hfov(), _aspect(), EYE)
			if Placement.zone_matches(zone, seen_at):
				options.append({"piece": piece, "side": side, "spot": spot})
	return {} if options.is_empty() else options.pick_random()


func _cover_in_use(piece: Dictionary) -> bool:
	for t: Node3D in _targets:
		if t.from_cover() and absf(wrapf(t.bearing - piece.bearing, -180.0, 180.0)) < 15.0:
			return true
	return false


## True once the first target of the fight is alive and in sight.
func _first_seen() -> bool:
	return is_instance_valid(_first_target) and _first_target.seen


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
		if dev_show == "cover":
			print("TARGET from_cover=%s zone=%s stance=%s offset=%.0f distance=%.1f" % [
				rec.from_cover, rec.zone, rec.stance, rec.offset, rec.distance])
		run_log.write_target(rec, won, "check" if _check else drill_id, settings, _fight_ttk,
			_fights_done)
	if _fights_done >= _run_length():
		_show_summary()
	else:
		_begin_wait(now)


func _show_summary() -> void:
	state = State.SUMMARY
	Config.save_settings(settings)
	var sight_label := "the red dot" if weapon_view.has_optic() else "iron sights"
	if _check:
		var version := int(drill.version)
		var sight := weapon_view.sight_name()
		var result := Summary.check_result(_run_recs, CHECK_TIMEOUT_MS)
		var earlier := RunLog.earlier_checks(RunLog.read_checks_file(), version, sight,
			settings.fov)
		if dev_show == "":
			RunLog.append_check(version, _check_cold, sight, settings, result)
		hud.show_summary(Summary.check_text(result, earlier, sight_label, settings.fov,
			CHECK_TIMEOUT_MS, _check_cold), [["SPACE", "START PRACTICE"], ["ESC", "MENU"]])
		_check_cold = false
		return
	var stats := Summary.stats(_run_recs)
	var run_sight := weapon_view.sight_name()
	var earlier_runs := RunLog.earlier_runs(RunLog.read_history_file(), drill_id, run_sight,
		settings.fov)
	hud.show_summary(Summary.run_text(stats, drill.name, _wins, _fights_done,
		settings[_ttk_key()], _run_start_ttk, earlier_runs,
		"%s at FOV %d" % [sight_label, settings.fov]),
		[["SPACE", "ANOTHER RUN"], ["ESC", "MENU"]])
	if dev_show == "":
		stats["arena_seed"] = _arena_seed
		RunLog.append_history(drill_id, run_sight, settings, _fights_done, _wins,
			_run_start_ttk, settings[_ttk_key()], stats)


# ---------- pause and leaving ----------

## Pausing throws away the fight in progress: its timings would be
## meaningless, so it is neither counted nor saved, and comes round again.
func _pause() -> void:
	_paused = true
	for t: Node3D in _targets:
		t.queue_free()
	_targets.clear()
	_fight_recs.clear()
	_stack_at_usec = 0
	state = State.WAITING
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	hud.show_pause("The target in progress was discarded.")


func _resume() -> void:
	_paused = false
	hud.hide_panel()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_begin_run(Time.get_ticks_usec())


func _leave() -> void:
	Config.save_settings(settings)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	exit_to_menu.emit()


# ---------- input ----------

func _input(event: InputEvent) -> void:
	if _paused:
		if event is InputEventKey and event.pressed and not event.echo \
				and event.keycode == KEY_ESCAPE:
			_resume()
		return
	if event is InputEventMouseMotion:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			return
		var c: Vector2 = event.screen_relative
		aim.apply_counts(c.x, c.y)
		if state == State.ACTIVE and _first_rec.react < 0.0 and _first_seen():
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
	elif event is InputEventMouseButton and event.pressed:
		if state == State.BRIEFING and event.button_index == MOUSE_BUTTON_LEFT:
			_begin_run(Time.get_ticks_usec())
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if state == State.ACTIVE and _first_rec.ads < 0.0 and _first_seen():
				_first_rec.ads = _ms_since(_first_rec, Time.get_ticks_usec())
	elif event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_ESCAPE:
				if state == State.BRIEFING or state == State.SUMMARY:
					_leave()
				else:
					_pause()
			KEY_SPACE:
				if state == State.BRIEFING:
					_begin_run(Time.get_ticks_usec())
				elif state == State.SUMMARY:
					if _check:
						_load_drill(settings.get("drill", "mixed"))
					else:
						_start_run()


# ---------- per frame ----------

func _process(delta: float) -> void:
	var now := Time.get_ticks_usec()
	_update_ads(delta)
	_update_fire(now)

	if not _paused:
		if state == State.WAITING and now >= _wait_until_usec:
			_begin_fight(now)
		elif state == State.ACTIVE:
			_update_fight(now, delta)

	camera.rotation = aim.camera_rotation()
	camera.fov = Sens.horizontal_to_vertical_fov(_current_hfov(), Placement.FOV_ASPECT)
	weapon_view.update(delta, now, aim, _ease(_ads_progress), camera.fov)
	# With iron sights the front post is the aiming mark, so the dot goes away.
	hud.update(now, weapon_view.has_optic() or _ads_progress < 0.6)


func _update_fight(now: int, delta: float) -> void:
	if _stack_at_usec > 0 and now >= _stack_at_usec:
		_stack_at_usec = 0
		_spawn_target(now, 1)
	var half := _current_hfov() / 2.0
	for t: Node3D in _targets:
		t.update(delta)
		if not t.seen:
			# Still behind cover: nothing is timed until it shows.
			if t.emerged():
				_mark_seen(t, now)
			continue
		if not t.from_cover() and Cover.blocked(_cover, EYE, t.aim_point()):
			t.undo_step()
		if not _check and now >= t.next_fire_usec:
			# The enemy shoots back in short bursts, heard from where it is.
			audio.enemy_shot(wrapf(t.bearing - aim.yaw_deg, -180.0, 180.0), t.distance)
			if t.burst_left <= 0:
				t.burst_left = randi_range(3, 6)
			t.burst_left -= 1
			t.next_fire_usec = now + (95_000 if t.burst_left > 0
				else int(randf_range(0.25, 0.55) * 1e6))
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


## True while the gun is in the player's hands: not on a panel, not paused.
func _playing() -> bool:
	return not _paused and (state == State.WAITING or state == State.ACTIVE)


func _update_ads(delta: float) -> void:
	var step: float = delta * 1000.0 / weapon.ads_time_ms
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and _playing()) or _force_ads:
		_ads_progress = minf(_ads_progress + step, 1.0)
	else:
		_ads_progress = maxf(_ads_progress - step, 0.0)
	aim.deg_per_count = _base_deg_per_count * lerpf(1.0, _ads_multiplier, _ads_progress)


func _update_fire(now: int) -> void:
	if not _playing() or not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
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
	audio.shot()

	if state == State.ACTIVE and not _targets.is_empty():
		# The shot counts against whichever target the sight is closest to.
		var view := aim.direction()
		var aimed_at: Node3D = null
		var best_angle := INF
		var struck: Node3D = null
		var struck_kind := Geo.MISS
		for t: Node3D in _targets:
			if not t.seen:
				continue
			var angle := view.angle_to((t.aim_point() - EYE).normalized())
			if angle < best_angle:
				best_angle = angle
				aimed_at = t
			var kind: int = t.hit_test(EYE, dir)
			if kind != Geo.MISS and (struck == null or t.distance < struck.distance):
				struck = t
				struck_kind = kind
		if aimed_at == null:
			aim.add_degrees(randf_range(-1.0, 1.0) * weapon.recoil_yaw_deg, weapon.recoil_pitch_deg)
			return
		# A bullet that meets cover before the target stops there.
		if struck != null and Cover.ray_distance(_cover, EYE, dir) < struck.distance - 0.3:
			struck = null
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
	var killed: bool = t.health <= 0.0
	hud.hit(now, killed)
	if killed:
		audio.kill(kind == Geo.HEAD)
		rec.kill = _ms_since(rec, now)
		_remove_target(t)
	else:
		audio.hit(kind == Geo.HEAD)
