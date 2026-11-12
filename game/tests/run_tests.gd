extends SceneTree
## Headless checks of the sensitivity math and count accumulation.
## Run: godot --headless --path game --script res://tests/run_tests.gd

const Sens = preload("res://scripts/sens.gd")
const AimState = preload("res://scripts/aim_state.gd")
const Geo = preload("res://scripts/target_geometry.gd")
const Config = preload("res://scripts/config.gd")
const Target = preload("res://scripts/target.gd")
const Placement = preload("res://scripts/placement.gd")
const Summary = preload("res://scripts/summary.gd")
const RunLog = preload("res://scripts/run_log.gd")
const SpatialSteps = preload("res://scripts/spatial_steps.gd")
const Cover = preload("res://scripts/cover.gd")
const GunAudio = preload("res://scripts/gun_audio.gd")

var _failures := 0


func _init() -> void:
	_test_known_values()
	_test_round_trip()
	_test_fov()
	_test_accumulation()
	_test_pitch_clamp()
	_test_ads_math()
	_test_hits()
	_test_median()
	_test_placement()
	_test_summary()
	_test_spatial_steps()
	_test_session_check()
	_test_counts_toward()
	_test_monitor_detection()
	_test_run_history()
	_test_cover()
	_test_gun_audio()
	_test_arena()
	print("FAILED: %d" % _failures if _failures else "ALL TESTS PASSED")
	quit(1 if _failures else 0)


func _check(name: String, got: float, want: float, tol: float) -> void:
	if absf(got - want) > tol:
		_failures += 1
		print("FAIL %s: got %.9f want %.9f" % [name, got, want])
	else:
		print("ok   %s" % name)


func _test_known_values() -> void:
	# CS-style: yaw 0.022, sens 1.0, 800 DPI -> 16363.64 counts, 51.95 cm.
	_check("cs counts/360", Sens.counts_per_360(0.022, 1.0), 16363.636364, 1e-5)
	_check("cs cm/360", Sens.cm_per_360(800.0, 0.022, 1.0), 51.954545, 1e-5)
	# Yaw 0.0066, sens 5.0, 800 DPI -> 10909.09 counts, 34.64 cm.
	_check("0.0066 counts/360", Sens.counts_per_360(0.0066, 5.0), 10909.090909, 1e-5)
	_check("0.0066 cm/360", Sens.cm_per_360(800.0, 0.0066, 5.0), 34.636364, 1e-5)


func _test_round_trip() -> void:
	var sens := Sens.sensitivity_for_cm_per_360(1600.0, 0.0066, 40.0)
	_check("sens<->cm round trip", Sens.cm_per_360(1600.0, 0.0066, sens), 40.0, 1e-9)


func _test_fov() -> void:
	# 90 horizontal at 4:3 is 73.74 vertical.
	_check("hfov 90 @4:3", Sens.horizontal_to_vertical_fov(90.0, 4.0 / 3.0), 73.739795, 1e-5)
	# 120 horizontal at 16:9: 2*atan(tan(60)/(16/9)) = 2*atan(0.974279) = 88.5072 vertical.
	_check("hfov 120 @16:9", Sens.horizontal_to_vertical_fov(120.0, 16.0 / 9.0), 88.507155, 1e-5)
	var v := Sens.horizontal_to_vertical_fov(103.0, 16.0 / 9.0)
	_check("fov round trip", Sens.vertical_to_horizontal_fov(v, 16.0 / 9.0), 103.0, 1e-9)


func _test_accumulation() -> void:
	# One million single-count events must land exactly where one big move would.
	var aim := AimState.new()
	aim.deg_per_count = Sens.degrees_per_count(0.0066, 5.0)
	for i in 1_000_000:
		aim.apply_counts(1.0, 0.0)
	_check("1e6 single counts", aim.yaw_deg, 1_000_000 * 0.0066 * 5.0, 1e-6)
	# Right then left by the same counts returns to zero.
	for i in 1_000_000:
		aim.apply_counts(-1.0, 0.0)
	_check("returns to zero", aim.yaw_deg, 0.0, 1e-6)
	_check("net counts zero", aim.counts_x, 0.0, 0.0)


func _test_ads_math() -> void:
	# Zooming 1.3x must shrink tan(fov/2) by exactly 1.3 (about 95.38 from 110).
	var zoomed := Sens.zoomed_fov(110.0, 1.3)
	_check("zoomed fov", tan(deg_to_rad(zoomed) / 2.0) * 1.3, tan(deg_to_rad(55.0)), 1e-9)
	_check("zoomed fov approx", zoomed, 95.38, 0.01)
	_check("zoom 1x unchanged", Sens.zoomed_fov(110.0, 1.0), 110.0, 1e-9)
	# Coefficient 0 is focal-length scaling: multiplier equals 1/zoom.
	var v_hip := Sens.horizontal_to_vertical_fov(110.0, 16.0 / 9.0)
	var v_ads := Sens.horizontal_to_vertical_fov(Sens.zoomed_fov(110.0, 1.3), 16.0 / 9.0)
	_check("ads mult k=0", Sens.relative_ads_multiplier(v_hip, v_ads, 0.0), 1.0 / 1.3, 1e-9)
	var m := Sens.relative_ads_multiplier(v_hip, v_ads, 1.33)
	_check("ads mult k=1.33 between 1/zoom and 1", float(m > 1.0 / 1.3 and m < 1.0), 1.0, 0.0)
	_check("same fov gives 1", Sens.relative_ads_multiplier(v_hip, v_hip, 1.33), 1.0, 1e-12)
	# Targets at 120 look 57.7% of their size at 90.
	_check("on-screen scale", Sens.on_screen_scale(120.0, 90.0), 0.577350, 1e-5)


func _test_hits() -> void:
	var eye := Vector3(0, 1.7, 0)
	var feet := Vector3(0, 0, -20)
	var head_c := feet + Vector3(0, 1.62, 0)
	var chest := (feet + Vector3(0, 1.2, 0) - eye).normalized()
	var head := (head_c - eye).normalized()
	var beside := (feet + Vector3(0.6, 1.2, 0) - eye).normalized()
	var above := (feet + Vector3(0, 2.2, 0) - eye).normalized()
	_check("chest is body", Geo.ray_hit(eye, chest, feet, 1.5, head_c), Geo.BODY, 0.0)
	_check("head is head", Geo.ray_hit(eye, head, feet, 1.5, head_c), Geo.HEAD, 0.0)
	_check("beside misses", Geo.ray_hit(eye, beside, feet, 1.5, head_c), Geo.MISS, 0.0)
	_check("above misses", Geo.ray_hit(eye, above, feet, 1.5, head_c), Geo.MISS, 0.0)
	_check("behind misses", Geo.ray_hit(eye, -chest, feet, 1.5, head_c), Geo.MISS, 0.0)
	_test_stances(eye)
	# The view direction must agree with the bearing convention used for targets.
	var aim := AimState.new()
	aim.yaw_deg = 90.0
	_check("yaw 90 faces +x", aim.direction().x, 1.0, 1e-9)
	aim.yaw_deg = 0.0
	_check("yaw 0 faces -z", aim.direction().z, -1.0, 1e-9)
	aim.add_degrees(0.0, 30.0)
	_check("pitch up raises y", aim.direction().y, 0.5, 1e-9)


func _aim_at(eye: Vector3, t: Node3D, height: float) -> Vector3:
	return (Vector3(t.position.x, height, t.position.z) - eye).normalized()


func _test_stances(eye: Vector3) -> void:
	# Bearing 0 at 20 m with no strafing puts the target at (0, 0, -20).
	var stand: Node3D = Target.new()
	stand.setup("stand", 0.0, 20.0, 150.0, 0.0)
	_check("target position z", stand.position.z, -20.0, 1e-9)
	_check("stand chest hit", stand.hit_test(eye, _aim_at(eye, stand, 1.2)), Geo.BODY, 0.0)
	_check("stand head hit", stand.hit_test(eye, _aim_at(eye, stand, 1.62)), Geo.HEAD, 0.0)

	var crouch: Node3D = Target.new()
	crouch.setup("crouch", 0.0, 20.0, 150.0, 0.0)
	_check("crouch: chest height misses", crouch.hit_test(eye, _aim_at(eye, crouch, 1.35)), Geo.MISS, 0.0)
	_check("crouch: low body hit", crouch.hit_test(eye, _aim_at(eye, crouch, 0.6)), Geo.BODY, 0.0)
	_check("crouch: head hit", crouch.hit_test(eye, _aim_at(eye, crouch, 1.07)), Geo.HEAD, 0.0)

	var prone: Node3D = Target.new()
	prone.setup("prone", 0.0, 20.0, 150.0, 3.0)
	prone.update(0.5)
	_check("prone does not strafe", prone.bearing, 0.0, 1e-9)
	_check("prone: standing height misses", prone.hit_test(eye, _aim_at(eye, prone, 1.2)), Geo.MISS, 0.0)
	# Lying facing the player, the head is in front of the body at ground level.
	_check("prone: centre is the head", prone.hit_test(eye, _aim_at(eye, prone, 0.2)), Geo.HEAD, 0.0)
	var shoulder := (prone.position + Vector3(0.2, 0.15, 0) - eye).normalized()
	_check("prone: shoulder is body", prone.hit_test(eye, shoulder), Geo.BODY, 0.0)

	var drop: Node3D = Target.new()
	drop.setup("dropshot", 0.0, 20.0, 150.0, 0.0)
	_check("dropshot starts upright", drop.body_top, 1.5, 1e-9)
	drop.update(0.5)
	_check("dropshot stays up until shot at", drop.body_top, 1.5, 1e-9)
	drop.shot_at()
	drop.update(0.3)
	_check("dropshot goes prone when shot at", drop.body_top, 0.35, 1e-9)
	_check("dropshot: old chest aim now misses", drop.hit_test(eye, _aim_at(eye, drop, 1.2)), Geo.MISS, 0.0)

	var jump: Node3D = Target.new()
	jump.setup("jump", 0.0, 20.0, 150.0, 0.0)
	var peak := 0.0
	for i in 200:
		jump.update(0.01)
		peak = maxf(peak, jump.position.y)
	_check("jump reaches its apex", peak, 0.9, 0.01)

	for t: Node3D in [stand, crouch, prone, drop, jump]:
		t.free()


func _test_median() -> void:
	_check("median odd", Config.median([5.0, 1.0, 3.0]), 3.0, 0.0)
	_check("median even", Config.median([4.0, 1.0, 3.0, 2.0]), 2.5, 0.0)


func _test_pitch_clamp() -> void:
	var aim := AimState.new()
	aim.deg_per_count = 1.0
	aim.apply_counts(0.0, -500.0)
	_check("pitch clamps up", aim.pitch_deg, 89.0, 0.0)
	aim.apply_counts(0.0, 1000.0)
	_check("pitch clamps down", aim.pitch_deg, -89.0, 0.0)


func _test_placement() -> void:
	# A 27 inch 16:9 screen is 59.77 by 33.62 cm.
	var half := Placement.screen_half_cm(27.0, 16.0 / 9.0)
	_check("screen half width cm", half.x, 29.886, 0.01)
	_check("screen half height cm", half.y, 16.811, 0.01)
	var reach := Placement.screen_visual_half_deg(27.0, 60.0, 16.0 / 9.0)
	_check("screen reach sideways deg", reach.x, 26.477, 0.01)
	_check("screen reach up deg", reach.y, 15.652, 0.01)
	_check("ring 0-2.5", float(Placement.ecc_bin(2.4) == "0-2.5"), 1.0, 0.0)
	_check("ring 5-10", float(Placement.ecc_bin(5.0) == "5-10"), 1.0, 0.0)
	_check("ring 20+", float(Placement.ecc_bin(31.0) == "20+"), 1.0, 0.0)

	seed(11)
	var aim := AimState.new()
	aim.yaw_deg = 40.0
	var eye := Vector3(0, 1.7, 0)
	var settings := {"monitor_diagonal_in": 27.0, "view_distance_cm": 60.0}
	var drill := {
		"zones": {"center": 1, "mid": 2, "far": 2}, "vertical_chance": 0.3,
		"stances": {"stand": 4, "crouch": 1, "prone": 1, "jump": 1, "dropshot": 1},
	}
	var on_screen := 0
	var ring_matches := 0
	var footing_ok := 0
	var in_range := 0
	for i in 400:
		var p := Placement.place(drill, settings, aim, 110.0, 16.0 / 9.0, eye)
		on_screen += int(absf(wrapf(p.bearing - aim.yaw_deg, -180.0, 180.0)) < 55.0)
		ring_matches += int(p.zone == Placement.ecc_bin(p.ecc))
		footing_ok += int(p.base == 0.0 or p.base >= 1.0)
		in_range += int(p.in_view and p.distance >= 4.0 and p.distance <= 60.0)
	_check("placed on screen", on_screen, 400, 0)
	_check("ring matches measured angle", ring_matches, 400, 0)
	_check("on the ground or clearly raised", footing_ok, 400, 0)
	_check("distance in range", in_range, 400, 0)

	var off := {"zones": {"offscreen": 1}, "vertical_chance": 0.0, "stances": {"stand": 1}}
	var outside := 0
	for i in 200:
		var p := Placement.place(off, settings, aim, 110.0, 16.0 / 9.0, eye)
		outside += int(not p.in_view
			and absf(wrapf(p.bearing - aim.yaw_deg, -180.0, 180.0)) >= 60.0)
	_check("off-screen zone is outside the view", outside, 200, 0)
	var behind := 0
	for i in 200:
		behind += int(absf(Placement.off_screen_offset("behind", 110.0)) >= 115.0)
	_check("behind is well past the screen edge", behind, 200, 0)


func _rec(zone: String, stance: String, ecc: float, direction: float, react: float,
		first_hit: float, kill: float, shots: int, hits: int) -> Dictionary:
	return {
		"zone": zone, "stance": stance, "ecc": ecc, "direction": direction, "react": react,
		"first_shot": first_hit - 20.0 if first_hit >= 0.0 else -1.0, "first_hit": first_hit,
		"kill": kill, "shots": shots, "hits": hits, "headshots": 0, "stack_index": 0,
		"offset": 0.0, "height": 0.0, "flick_deg": ecc, "distance": 20.0,
		"in_view_at_spawn": true, "pre_ads": false, "in_view": 0.0, "ads": 150.0,
		"first_shot_error": 0.5, "sight": "optic",
	}


func _test_summary() -> void:
	var recs := [
		_rec("5-10", "stand", 8.0, 0.0, 200.0, 500.0, 900.0, 10, 6),
		_rec("5-10", "stand", 9.0, 180.0, 300.0, 700.0, 1300.0, 10, 4),
		_rec("5-10", "crouch", 7.0, 90.0, 400.0, 800.0, 1000.0, 5, 5),
		_rec("20+", "prone", 24.0, 0.0, 350.0, -1.0, -1.0, 5, 0),
	]
	var s := Summary.stats(recs)
	_check("summary shots", s.shots, 30, 0)
	_check("summary hit rate", s.hit_rate, 50.0, 1e-9)
	_check("summary median react", Config.median(s.stage.react), 325.0, 1e-9)
	_check("summary median kill", Config.median(s.stage.kill), 1000.0, 1e-9)
	_check("summary ring react", Config.median(s.zone_react["5-10"]), 300.0, 1e-9)
	_check("summary ring hits counted", s.zone_hit["5-10"].size(), 3, 0)
	_check("summary missed target has no first hit", float(s.zone_hit.has("20+")), 0.0, 0.0)
	_check("summary to the side", s.level.size(), 2, 0)
	_check("summary above or below", s.steep.size(), 1, 0)
	_check("summary stand hit-to-kill", Config.median(s.stance_kill["stand"]), 500.0, 1e-9)
	var text := Summary.run_text(s, "Mixed", 3, 4, 1400.0, 1500.0)
	_check("summary text names the ring", float("5 to 10 deg" in text), 1.0, 0.0)
	_check("summary text shows level", float("kills in 1400 ms" in text), 1.0, 0.0)
	var line := Summary.fight_text(false, 1500.0, [recs[3]])
	_check("fight text for a loss", float(line.begins_with("LOST") and "0/5 hits" in line), 1.0, 0.0)
	var row := RunLog.target_row(recs[0], true, "mixed",
		{"fov": 110.0, "sensitivity": 6.9, "dpi": 800.0}, 1500.0, 1, 0)
	_check("log row matches its header", row.split(",").size(),
		RunLog.TARGET_HEADER.split(",").size(), 0)


func _test_spatial_steps() -> void:
	# Stored azimuths run anticlockwise, so a source to the right is 270.
	_check("step ahead", float(SpatialSteps.snap(0.0, 0.0) == Vector2i(0, 0)), 1.0, 0.0)
	_check("step to the right", float(SpatialSteps.snap(90.0, 0.0) == Vector2i(270, 0)), 1.0, 0.0)
	_check("step to the left", float(SpatialSteps.snap(-90.0, 0.0) == Vector2i(90, 0)), 1.0, 0.0)
	_check("step behind", float(SpatialSteps.snap(180.0, 0.0) == Vector2i(180, 0)), 1.0, 0.0)
	_check("step snaps to 5 deg", float(SpatialSteps.snap(-2.4, 3.0) == Vector2i(0, 0)), 1.0, 0.0)
	_check("step wraps", float(SpatialSteps.snap(1.0, 0.0) == Vector2i(0, 0)), 1.0, 0.0)
	_check("step above", float(SpatialSteps.snap(-50.0, 40.0) == Vector2i(45, 30)), 1.0, 0.0)
	_check("step below", float(SpatialSteps.snap(20.0, -20.0) == Vector2i(345, -30)), 1.0, 0.0)
	var missing := 0
	for ele: int in SpatialSteps.GRID:
		for azi in range(0, 360, SpatialSteps.GRID[ele]):
			for v in 3:
				missing += int(not FileAccess.file_exists(
					"%s/step%d_azi_%d_ele_%d.wav" % [SpatialSteps.DIR, v, azi, ele]))
	_check("every stored direction has its sounds", missing, 0, 0)
	_check("step level near", SpatialSteps.level_db(2.0), 0.0, 1e-9)
	_check("step level at double distance", SpatialSteps.level_db(10.0), -6.0206, 0.001)
	_check("step level floor", SpatialSteps.level_db(5000.0), SpatialSteps.MIN_DB, 1e-9)


func _test_session_check() -> void:
	var recs := [
		_rec("5-10", "stand", 8.0, 0.0, 200.0, 500.0, 900.0, 10, 6),
		_rec("5-10", "stand", 9.0, 180.0, 300.0, 700.0, 1300.0, 10, 4),
		_rec("20+", "prone", 24.0, 0.0, 350.0, -1.0, -1.0, 5, 0),
	]
	var result := Summary.check_result(recs, 4000.0)
	_check("check counts kills", result.kills, 2, 0)
	# 900, 1300 and the 4000 limit for the one not killed: the middle is 1300.
	_check("check score counts a miss as the limit", result.score, 1300.0, 1e-9)
	var settings := {"fov": 110.0, "sensitivity": 6.8, "dpi": 800.0}
	var row := RunLog.check_row(1, true, "optic", settings, result, 1790000000)
	_check("check row matches its header", row.split(",").size(),
		RunLog.CHECK_HEADER.split(",").size(), 0)
	var csv := "\n".join([RunLog.CHECK_HEADER, row,
		RunLog.check_row(1, false, "optic", settings, result, 1790000100),
		RunLog.check_row(1, true, "irons", settings, result, 1790000200),
		RunLog.check_row(1, true, "optic", {"fov": 100.0, "sensitivity": 6.8, "dpi": 800.0},
			result, 1790000300),
		RunLog.check_row(2, true, "optic", settings, result, 1790000400), ""])
	var earlier := RunLog.earlier_checks(csv, 1, "optic", 110.0)
	_check("only cold checks at the same sight, FOV and version compare", earlier.size(), 1, 0)
	_check("earlier check keeps its score", earlier[0].score, 1300.0, 1e-9)
	var text := Summary.check_text(result, earlier, "the red dot", 110.0, 4000.0, true)
	_check("check text shows the score and history",
		float("Typical time to kill: 1300 ms" in text and "best so far" in text), 1.0, 0.0)
	# Every step of the fixed sequence must be something placement understands.
	var drill := Config.load_json("res://drills/check.json")
	var bad := 0
	for step: Array in drill.sequence:
		var known: bool = Placement.VISUAL_ZONES.has(step[0]) or step[0] in ["offscreen", "behind"]
		bad += int(not known or not step[1] in Target.STANCES)
	_check("check sequence is valid", bad, 0, 0)
	_check("check sequence length", drill.sequence.size(), 16, 0)
	# The same seed must give the same placement.
	var aim := AimState.new()
	var spec := {"zones": {"far": 1}, "stances": {"stand": 1}, "vertical_chance": 0.0}
	var s2 := {"monitor_diagonal_in": 34.0, "view_distance_cm": 60.0}
	seed(123)
	var a := Placement.place(spec, s2, aim, 110.0, 21.0 / 9.0, Vector3(0, 1.7, 0))
	seed(123)
	var b := Placement.place(spec, s2, aim, 110.0, 21.0 / 9.0, Vector3(0, 1.7, 0))
	randomize()
	_check("seeded placement repeats", absf(a.bearing - b.bearing) + absf(a.distance - b.distance), 0.0, 1e-9)


func _test_counts_toward() -> void:
	# Mouse right is +x, mouse up is -y.
	_check("toward: right at a target to the right", AimState.counts_toward(5, 0, 20, 0), 5.0, 1e-9)
	_check("toward: left away from a target to the right", AimState.counts_toward(-5, 0, 20, 0), -5.0, 1e-9)
	_check("toward: up at a target above", AimState.counts_toward(0, -5, 0, 10), 5.0, 1e-9)
	_check("toward: sideways across a target above", AimState.counts_toward(5, 0, 0, 10), 0.0, 1e-9)
	_check("toward: either way round for one behind", AimState.counts_toward(-5, 0, 170, 0), 5.0, 1e-9)


func _test_monitor_detection() -> void:
	_check("80 x 33 cm is a 34 inch screen", Config.diagonal_in_from_cm(80, 33), 34.07, 0.01)
	_check("monitor query, one screen", Config.parse_monitor_query("80,33\r\n"), 34.07, 0.01)
	_check("monitor query, two screens is ambiguous", Config.parse_monitor_query("80,33\n60,34\n"), -1.0, 0.0)
	_check("monitor query, no size reported", Config.parse_monitor_query("0,0\n"), -1.0, 0.0)
	_check("monitor query, nothing", Config.parse_monitor_query(""), -1.0, 0.0)


func _test_run_history() -> void:
	var s := Summary.stats([_rec("5-10", "stand", 8.0, 0.0, 200.0, 500.0, 900.0, 10, 6)])
	var settings := {"fov": 110.0, "sensitivity": 6.9, "dpi": 800.0}
	var row := RunLog.history_row("mixed", "optic", settings, 20, 14, 1500.0, 1320.0, s, 1790000000)
	_check("history row matches its header", row.split(",").size(),
		RunLog.HISTORY_HEADER.split(",").size(), 0)
	var csv := "\n".join([RunLog.HISTORY_HEADER, row,
		RunLog.history_row("mixed", "irons", settings, 20, 14, 1500.0, 1700.0, s, 1790000100),
		RunLog.history_row("offscreen", "optic", settings, 20, 14, 1500.0, 1800.0, s, 1790000200),
		RunLog.history_row("mixed", "optic", settings, 20, 15, 1320.0, 1250.0, s, 1790000300), ""])
	var earlier := RunLog.earlier_runs(csv, "mixed", "optic", 110.0)
	_check("earlier runs: same drill, sight and FOV only", earlier.size(), 2, 0)
	_check("earlier runs keep their level, oldest first", earlier[0].level, 1320.0, 1e-9)
	var text := Summary.run_text(s, "Mixed", 14, 20, 1200.0, 1250.0, earlier, "the red dot at FOV 110")
	_check("run text lists earlier levels", float("1320, 1250 ms   (2 runs)" in text), 1.0, 0.0)


func _test_cover() -> void:
	var eye := Vector3(0, 1.7, 0)
	# One wall 3.4 m wide and 2.4 m tall, 10 m due north.
	var wall := {"kind": "wall", "bearing": 0.0, "distance": 10.0,
		"half": Vector3(1.7, 1.2, 0.18), "tall": true}
	var pieces := [wall]
	_check("cover: straight at the wall hits it at its near face",
		Cover.ray_distance(pieces, eye, Vector3(0, 0, -1)), 9.82, 1e-6)
	_check("cover: a ray the other way hits nothing",
		float(is_inf(Cover.ray_distance(pieces, eye, Vector3(0, 0, 1)))), 1.0, 0.0)
	_check("cover: a point behind the wall is hidden",
		float(Cover.blocked(pieces, eye, Vector3(0, 1.1, -14))), 1.0, 0.0)
	_check("cover: a point beside the wall is visible",
		float(Cover.blocked(pieces, eye, Vector3(4, 1.1, -14))), 0.0, 0.0)
	_check("cover: a point in front of the wall is visible",
		float(Cover.blocked(pieces, eye, Vector3(0, 1.1, -6))), 0.0, 0.0)
	_check("cover: over the top of a low barrier is visible", float(Cover.blocked(
		[{"kind": "barriers", "bearing": 0.0, "distance": 10.0, "half": Vector3(2.4, 0.42, 0.32),
			"tall": false}], eye, Vector3(0, 1.1, -14))), 0.0, 0.0)
	_check("cover: standing in the wall counts as inside",
		float(Cover.inside(pieces, Vector3(1.0, 0, -10), 0.5)), 1.0, 0.0)
	_check("cover: standing clear of it does not",
		float(Cover.inside(pieces, Vector3(4.0, 0, -10), 0.5)), 0.0, 0.0)
	# The same wall turned to another bearing behaves the same way.
	var east := wall.duplicate()
	east.bearing = 90.0
	_check("cover: wall to the east blocks a point behind it",
		float(Cover.blocked([east], eye, Vector3(14, 1.1, 0))), 1.0, 0.0)

	# An enemy stepping out: hidden where it waits, visible once clear.
	var spot := Cover.peek(wall, 1.0)
	var hidden := deg_to_rad(spot.hidden_off)
	var out := deg_to_rad(spot.min_off)
	var d: float = spot.distance
	_check("peek: waits out of sight", float(Cover.blocked(pieces, eye,
		Vector3(sin(hidden) * d + 0.25, 1.1, -cos(hidden) * d))), 1.0, 0.0)
	_check("peek: whole body shows once out", float(Cover.blocked(pieces, eye,
		Vector3(sin(out) * d - 0.25, 1.1, -cos(out) * d))), 0.0, 0.0)
	var t: Node3D = Target.new()
	t.setup("stand", 0.0, d, 150.0, 2.0)
	t.setup_peek(0.0, 1.0, spot, 2.2)
	_check("peek: target starts unseen and not emerged", float(t.seen or t.emerged()), 0.0, 0.0)
	var steps := 0
	while not t.emerged() and steps < 200:
		t.update(0.01)
		steps += 1
	_check("peek: emerges within a second", float(steps < 100), 1.0, 0.0)
	for i in 600:
		t.update(0.01)
	_check("peek: never slides back behind the cover",
		float(t.bearing >= spot.min_off - 1e-6), 1.0, 0.0)
	t.free()

	# Measuring where a point is in the player's vision.
	var aim := AimState.new()
	var s := {"monitor_diagonal_in": 34.0, "view_distance_cm": 60.0}
	var ahead := Placement.measure(Vector3(0, 1.7, -20), s, aim, 110.0, 21.0 / 9.0, eye)
	_check("measure: dead ahead is on the crosshair", ahead.ecc, 0.0, 1e-6)
	var behind := Placement.measure(Vector3(0, 1.7, 20), s, aim, 110.0, 21.0 / 9.0, eye)
	_check("measure: directly behind is behind", float(behind.zone == "behind"), 1.0, 0.0)
	var side := Placement.measure(Vector3(20, 1.7, -2), s, aim, 110.0, 21.0 / 9.0, eye)
	_check("measure: far to the side is off screen", float(side.zone == "offscreen"), 1.0, 0.0)
	_check("zone match: on-screen point fits the centre zone",
		float(Placement.zone_matches("center", {"in_view": true, "ecc": 2.0, "zone": "0-2.5"})), 1.0, 0.0)
	_check("zone match: off-screen point does not",
		float(Placement.zone_matches("center", behind)), 0.0, 0.0)
	# Every piece of the real layout must leave the player a clear view of
	# open ground somewhere, and none may sit on top of another.
	var layout := Cover.layout()
	var clashes := 0
	for i in layout.size():
		for j in range(i + 1, layout.size()):
			var gap: float = (Cover.center(layout[i]) - Cover.center(layout[j])).length()
			clashes += int(gap < 4.0)
	_check("cover layout: no two pieces overlap", clashes, 0, 0)


func _test_gun_audio() -> void:
	# Stored azimuths run anticlockwise, so an enemy to the right is 270.
	_check("enemy fire: ahead", GunAudio.snap(0.0), 0, 0)
	_check("enemy fire: to the right", GunAudio.snap(90.0), 270, 0)
	_check("enemy fire: to the left", GunAudio.snap(-90.0), 90, 0)
	_check("enemy fire: behind", GunAudio.snap(180.0), 180, 0)
	_check("enemy fire: snaps to the nearest 10 degrees", GunAudio.snap(-14.0), 10, 0)
	_check("enemy fire: full level when close", GunAudio.enemy_level_db(4.0), GunAudio.ENEMY_DB, 1e-9)
	_check("enemy fire: 6 dB down at double the distance",
		GunAudio.enemy_level_db(16.0), GunAudio.ENEMY_DB - 6.0206, 1e-3)
	var hit := GunAudio.thwack_stream(GunAudio.HIT)
	_check("hit sound length", hit.data.size(), int(GunAudio.HIT.seconds * 48000) * 2, 0)
	var loud := 0
	for i in hit.data.size() / 2:
		loud = maxi(loud, absi(hit.data.decode_s16(i * 2)))
	_check("hit sound is not silent and does not clip", float(loud > 8000 and loud <= 30000), 1.0, 0.0)
	var missing := 0
	for azi in range(0, 360, GunAudio.AZIMUTH_STEP):
		for v in GunAudio.ENEMY_VARIANTS:
			missing += int(not FileAccess.file_exists(
				"res://assets/audio/gunfire/enemy_%d_azi_%d.wav" % [v, azi]))
	_check("enemy fire: a file for every direction", missing, 0, 0)


func _test_arena() -> void:
	var a := Cover.generate(12345)
	var b := Cover.generate(12345)
	var same := a.size() == b.size()
	for i in mini(a.size(), b.size()):
		same = same and a[i].kind == b[i].kind and is_equal_approx(a[i].bearing, b[i].bearing) \
			and is_equal_approx(a[i].distance, b[i].distance)
	_check("arena: the same seed gives the same arena", float(same), 1.0, 0.0)
	var other := Cover.generate(54321)
	var differs: bool = other.size() != a.size() or not is_equal_approx(other[0].bearing, a[0].bearing)
	_check("arena: another seed gives another arena", float(differs), 1.0, 0.0)
	# The rules must hold for every arena, so try a few hundred.
	var crowded := 0
	var out_of_range := 0
	var few_tall := 0
	var empty_side := 0
	for s in range(1, 301):
		var pieces := Cover.generate(s)
		var tall := 0
		var quadrants := [false, false, false, false]
		for i in pieces.size():
			var p: Dictionary = pieces[i]
			out_of_range += int(p.distance < Cover.NEAR or p.distance > Cover.FAR)
			if p.tall:
				tall += 1
				quadrants[int(p.bearing / 90.0) % 4] = true
			for j in range(i + 1, pieces.size()):
				var gap := absf(wrapf(p.bearing - pieces[j].bearing, -180.0, 180.0))
				crowded += int(gap < Cover.MIN_GAP_DEG)
		few_tall += int(tall < 6)
		empty_side += int(quadrants.has(false))
	_check("arena: no piece hides behind another", crowded, 0, 0)
	_check("arena: every piece is within range", out_of_range, 0, 0)
	_check("arena: at least six pieces an enemy can step out from", few_tall, 0, 0)
	_check("arena: tall cover on every side", empty_side, 0, 0)
	var s := Summary.stats([_rec("5-10", "stand", 8.0, 0.0, 200.0, 500.0, 900.0, 10, 6)])
	s["arena_seed"] = 777
	var row := RunLog.history_row("mixed", "optic", {"fov": 110.0, "sensitivity": 6.9, "dpi": 800.0},
		20, 14, 1500.0, 1320.0, s, 1790000000)
	_check("arena: the seed is saved with the run", float(row.ends_with(",777")), 1.0, 0.0)
