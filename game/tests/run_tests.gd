extends SceneTree
## Headless checks of the sensitivity math and count accumulation.
## Run: godot --headless --path game --script res://tests/run_tests.gd

const Sens = preload("res://scripts/sens.gd")
const AimState = preload("res://scripts/aim_state.gd")
const Geo = preload("res://scripts/target_geometry.gd")
const Config = preload("res://scripts/config.gd")
const Target = preload("res://scripts/target.gd")

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
