extends Node3D
## One enemy: where it is, how it stands and moves, and what can be hit.
## Stances: stand, crouch, prone, jump (keeps jumping), dropshot (drops prone
## the moment it is shot at). All sizes and timings are placeholders.

const Geo = preload("res://scripts/target_geometry.gd")
const EnemyModel = preload("res://scripts/enemy_model.gd")

const STANCES := ["stand", "crouch", "prone", "jump", "dropshot"]
const UPRIGHT := {"body_top": 1.5, "head": 1.62}
const CROUCHED := {"body_top": 0.95, "head": 1.07}
const LYING := {"body_top": 0.35, "head": 0.22}
const HEAD_FORWARD_WHEN_LYING := 0.25
const DROP_TIME := 0.25
const JUMP_APEX := 0.9
const JUMP_AIR_TIME := 0.85
const MESH_BODY_HEIGHT := 1.5
## Ways an enemy in the open can move, and how often each is chosen.
## The last four are straight runs, which the drill plans (it knows where the
## cover is): to a piece of cover, across the yard, away, or toward the player.
const PATTERNS := {"strafe": 1, "stutter": 1, "duck": 1, "hold": 2, "roam": 3,
	"to_cover": 3, "cross": 2, "flee": 2, "push": 2}
const RUN_PATTERNS := ["to_cover", "cross", "flee", "push"]
const RUN_SPEED := 4.4
const PEEK_WALK_SPEED := 2.2
const SPRINT_SPEED := 5.8
## A roaming enemy stays between these distances from the player.
const ROAM_NEAR_M := 7.0
const ROAM_FAR_M := 33.0

var stance := "stand"
var bearing := 0.0
var distance := 20.0
var health := 150.0
var strafe_speed := 0.0
## How it moves when out in the open; one of PATTERNS.
var pattern := "strafe"
## Set by the drill for an enemy at cover that will break from it and run to
## another piece: {"bearing", "side", "spot"} of where it is going.
var move_to_cover := {}
## Timing record for this target, filled in by the drill.
var rec := {}

var body_top := 1.5
var head_height := 1.62

## Height of the feet above the ground (standing on a raised platform).
var base_height := 0.0

## False while the target is still hidden behind cover; its timings start
## when it comes into sight.
var seen := true

## When this enemy next fires at the player, and how many shots remain in
## its current burst. Driven by the drill.
var next_fire_usec := 0
var burst_left := 0
## True if it announces itself by firing even where enemies do not
## otherwise shoot (an enemy that appeared out of view, too far to hear).
var loud := false
## When its next footstep is due.
var next_step_usec := 0

var _peek_center := 0.0
var _peek_side := 0.0
var _peek_spot := {}
var _peek_speed := 0.0
var _stepping_out := false
var _prev_bearing := 0.0
var _platform: MeshInstance3D
var _lying := 0.0
var _dropping := false
var _strafe_dir := 1.0
var _flip_in := 0.0
var _jump_t := -1.0
var _next_jump := 0.0
var _jump_height := 0.0
var _body: MeshInstance3D
var _head: MeshInstance3D
var _legs: MeshInstance3D
var _model: EnemyModel
var _last_speed := 0.0
var _paused := false
var _duck_in := 0.0
var _prev_distance := 0.0
var _peeks := false
var _peek_phase := ""
var _peek_wait := 0.0
var _running := false
var _run_target := Vector3.ZERO
var _after_run := "strafe"
var _run_cover := {}
var _run_speed := 4.4
var _heading := 0.0
var _roam_speed := 1.8
## How it moved in the last update, in m/s: x to its own left, y toward the
## player it is facing.
var _motion := Vector2.ZERO


func _init() -> void:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.42, 0.3, 0.26)
	_body = MeshInstance3D.new()
	var capsule := CapsuleMesh.new()
	capsule.radius = Geo.BODY_RADIUS
	capsule.height = MESH_BODY_HEIGHT
	_body.mesh = capsule
	_body.material_override = mat
	add_child(_body)
	_head = MeshInstance3D.new()
	var sphere := SphereMesh.new()
	sphere.radius = Geo.HEAD_RADIUS
	sphere.height = Geo.HEAD_RADIUS * 2.0
	_head.mesh = sphere
	_head.material_override = mat
	add_child(_head)
	# Legs stretched out behind a lying target, away from the player.
	_legs = MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(0.45, 0.25, 1.3)
	_legs.mesh = box
	_legs.material_override = mat
	_legs.position = Vector3(0, 0.125, -0.8)
	add_child(_legs)
	# The animated figure, when its files are installed. The plain shapes
	# above stay as the fallback for any stance it has no animation for.
	if EnemyModel.available():
		_model = EnemyModel.new()
		add_child(_model)


## Ground speed right now, in m/s (0 when standing still).
func _ground_speed() -> float:
	return _motion.length()


## Which animation suits what the target is doing right now. A moving
## enemy always faces the player, so which way it is travelling relative to
## that (toward, away, either side, or a diagonal) picks one of eight
## directions, and its speed picks walk, run or sprint.
func _model_state() -> String:
	if _lying >= 1.0:
		return "prone"
	if _lying > 0.0:
		# Going down: use the transition if there is one, else blend
		# straight to lying.
		return "drop" if EnemyModel.supports("drop") else "prone"
	if _jump_t >= 0.0:
		return "jump"
	if _motion.length() < 0.15:
		return "crouch" if stance == "crouch" else "idle"
	var state := EnemyModel.move_state(stance == "crouch", _motion.x, _motion.y)
	if EnemyModel.supports(state):
		return state
	return "crouch" if stance == "crouch" else "idle"


func _update_figure() -> void:
	var state := _model_state()
	var drawn := _model != null and EnemyModel.supports(state)
	_body.visible = not drawn
	_head.visible = not drawn
	_legs.visible = not drawn and _lying > 0.5
	if _model == null:
		return
	_model.visible = drawn
	if not drawn:
		return
	_last_speed = _ground_speed()
	var speed := 1.0
	if state == "drop":
		# The whole movement has to fit in the time the drop takes.
		speed = _model.length("drop") / DROP_TIME
	elif state == "jump":
		speed = _model.length("jump") / JUMP_AIR_TIME
	elif EnemyModel.made_for(state) > 0.1:
		# Keep the feet in step with how fast it is really moving.
		speed = clampf(_ground_speed() / EnemyModel.made_for(state), 0.4, 1.8)
	_model.play(state, speed)


## Called when the target is killed. With an animated figure it falls and
## lies for a moment before it is cleared away; otherwise it just goes.
## The fall depends on what it was doing: lying, crouching, hit in the
## head, running, walking or standing, with some variety among the last.
func die(headshot := false) -> void:
	var choices := ["die", "die_2"]
	if _lying > 0.5:
		choices = ["die_prone"]
	elif stance == "crouch":
		choices = ["die_crouch"]
	elif headshot:
		choices = ["die_head"]
	elif _last_speed > EnemyModel.RUN_ABOVE:
		choices = ["die_run"]
	elif _last_speed > 0.0:
		choices = ["die_walk", "die", "die_2"]
	var usable := choices.filter(func(c: String) -> bool: return EnemyModel.supports(c))
	if _model == null or usable.is_empty():
		queue_free()
		return
	var fall: String = usable.pick_random()
	_body.visible = false
	_head.visible = false
	_legs.visible = false
	if _platform:
		_platform.visible = false
	_model.visible = true
	_model.play(fall, 1.3)
	# Leave it lying for a moment after the fall ends.
	get_tree().create_timer(minf(_model.length(fall) / 1.3 + 0.7, 3.5)).timeout.connect(queue_free)




## Height above the feet that the player is expected to aim at, per stance.
static func aim_height_for(p_stance: String) -> float:
	var top: float = UPRIGHT.body_top
	if p_stance == "crouch":
		top = CROUCHED.body_top
	elif p_stance == "prone":
		top = LYING.body_top
	return top * 0.75


func setup(p_stance: String, p_bearing: float, p_distance: float, p_health: float,
		p_strafe_speed: float, p_base_height := 0.0, p_varied := false) -> void:
	stance = p_stance
	bearing = p_bearing
	distance = p_distance
	health = p_health
	base_height = p_base_height
	# A target up on a platform holds its position, like someone in a window.
	strafe_speed = 0.0 if base_height > 0.0 else p_strafe_speed
	if base_height > 0.0:
		_platform = MeshInstance3D.new()
		var box := BoxMesh.new()
		box.size = Vector3(1.6, base_height, 1.6)
		_platform.mesh = box
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(0.4, 0.39, 0.36)
		_platform.material_override = mat
		add_child(_platform)
	_lying = 1.0 if stance == "prone" else 0.0
	_strafe_dir = 1.0 if randf() < 0.5 else -1.0
	_flip_in = randf_range(0.4, 1.2)
	_next_jump = randf_range(0.0, 0.4)
	pattern = "strafe"
	if p_varied and base_height == 0.0 and (stance == "stand" or stance == "crouch"):
		pattern = _pick_pattern()
		_duck_in = randf_range(0.5, 1.2)
		_heading = (randi() % 8) * 45.0
		_roam_speed = 1.7 if stance == "crouch" else 1.8
		if pattern in RUN_PATTERNS:
			stance = "stand"
	update(0.0)


## Start hidden behind a piece of cover and step out to one side. `spot`
## comes from Cover.peek(); `side` is -1 for the player's left, +1 for right.
## Call after setup().
func setup_peek(cover_bearing: float, side: float, spot: Dictionary, speed: float,
		p_peeks := false) -> void:
	_peeks = p_peeks
	pattern = "strafe"
	_peek_center = cover_bearing
	_peek_side = side
	_peek_spot = spot
	_peek_speed = speed
	_stepping_out = true
	seen = false
	distance = spot.distance
	bearing = cover_bearing + side * float(spot.hidden_off)
	base_height = float(spot.get("stand_height", 0.0))
	if base_height > 0.0:
		# Up on a platform: it steps out and then holds its position, since
		# there is nowhere to walk to.
		strafe_speed = 0.0
	if stance == "prone":
		stance = "crouch"
		_lying = 0.0
	update(0.0)


## True if the last update moved it across the ground.
func moving() -> bool:
	return absf(bearing - _prev_bearing) > 1e-7 or absf(distance - _prev_distance) > 1e-7


func from_cover() -> bool:
	return _peek_side != 0.0


## True once enough of the target shows past the edge of its cover.
func emerged() -> bool:
	return _peek_side == 0.0 \
		or (bearing - _peek_center) * _peek_side >= float(_peek_spot.emerge_off)


## Take back the last movement and turn round: used when a step would have
## carried the target out of sight behind cover.
func undo_step() -> void:
	bearing = _prev_bearing
	distance = _prev_distance
	_strafe_dir = -_strafe_dir
	if pattern == "roam":
		# Pick a new way to go next update.
		_flip_in = 0.0
	else:
		_flip_in = randf_range(0.4, 1.2)
	_running = false
	update(0.0)


## Called when the player fires at this target.
func shot_at() -> void:
	if stance == "dropshot":
		_dropping = true


func _pick_pattern() -> String:
	var total := 0
	for key: String in PATTERNS:
		total += int(PATTERNS[key])
	var roll := randi() % total
	for key: String in PATTERNS:
		roll -= int(PATTERNS[key])
		if roll < 0:
			return key
	return "strafe"


## Movement for an enemy in the open, by pattern. Real players do not just
## rock from side to side: some hold an angle, some run across, some move in
## bursts, some bob up and down, some push toward you.
func _move_in_open(delta: float) -> void:
	var speed := strafe_speed * (0.5 if stance == "crouch" else 1.0)
	var flips := true
	match pattern:
		"hold":
			speed = 0.0
			flips = false
		"stutter":
			flips = false
			_flip_in -= delta
			if _flip_in <= 0.0:
				_paused = not _paused
				_flip_in = randf_range(0.25, 0.7) if _paused else randf_range(0.3, 0.9)
				if not _paused and randf() < 0.5:
					_strafe_dir = -_strafe_dir
			if _paused:
				speed = 0.0
		"duck":
			_duck_in -= delta
			if _duck_in <= 0.0:
				stance = "stand" if stance == "crouch" else "crouch"
				_duck_in = randf_range(0.5, 1.3)
		"roam":
			# Any of eight directions, at a walk, run or sprint, changing
			# every second or so: forward, back, sideways and the diagonals.
			_flip_in -= delta
			if _flip_in <= 0.0:
				_heading = (randi() % 8) * 45.0
				_roam_speed = 1.7 if stance == "crouch" else [1.8, 1.8, 4.4, 5.8][randi() % 4]
				_flip_in = randf_range(0.6, 1.5)
			var toward := cos(deg_to_rad(_heading))
			# Turn back rather than run into the player or out of the yard.
			if (distance < ROAM_NEAR_M and toward > 0.0) or (distance > ROAM_FAR_M and toward < 0.0):
				_heading = wrapf(180.0 - _heading, 0.0, 360.0)
				toward = -toward
			bearing += rad_to_deg(_roam_speed * sin(deg_to_rad(_heading)) * delta / distance)
			distance -= _roam_speed * toward * delta
			return
	if flips:
		_flip_in -= delta
		if _flip_in <= 0.0:
			_strafe_dir = -_strafe_dir
			_flip_in = randf_range(0.4, 1.2)
	bearing += rad_to_deg(speed * _strafe_dir * delta / distance)
	if _peek_side != 0.0 \
			and (bearing - _peek_center) * _peek_side < float(_peek_spot.min_off):
		# Never slide back behind the cover it came from.
		bearing = _peek_center + _peek_side * float(_peek_spot.min_off)
		_strafe_dir = _peek_side


## Run in a straight line to a point on the ground, then do `after`:
## "strafe" or "hold" where it stops, or "peek" to settle behind the piece
## of cover described by `cover` ({"bearing", "side", "spot"}) and peek out
## from it. It keeps facing the player as it runs, so the run may be
## forward, backward, sideways or diagonal.
func run_to(point: Vector3, after: String, cover := {}, speed := RUN_SPEED) -> void:
	_run_speed = speed
	_run_target = Vector3(point.x, 0.0, point.z)
	_after_run = after
	_run_cover = cover
	_running = true
	if stance == "crouch":
		stance = "stand"


func running() -> bool:
	return _running


## True if being out of sight is part of what this enemy is doing, so the
## drill should not push it back into view.
func may_hide() -> bool:
	return _peek_side != 0.0 or (_running and _after_run == "peek")


## The spot fully behind a piece of cover on one side, on the ground.
## `cover` is {"bearing", "side", "spot"} with spot from Cover.peek().
static func tucked_point(cover: Dictionary) -> Vector3:
	var b := deg_to_rad(float(cover.bearing) + float(cover.side) * _tucked_off(cover.spot))
	return Vector3(sin(b), 0.0, -cos(b)) * float(cover.spot.distance)


## How far inside the edge of its cover a hidden enemy stands, in degrees
## from the middle of the piece.
static func _tucked_off(spot: Dictionary) -> float:
	return float(spot.emerge_off) - (float(spot.min_off) - float(spot.emerge_off)) * 0.7


func _move_running(delta: float) -> void:
	var here := Vector3(position.x, 0.0, position.z)
	var to := _run_target - here
	var step := _run_speed * delta
	if to.length() <= step:
		here = _run_target
		_running = false
	else:
		here += to.normalized() * step
	distance = maxf(here.length(), 0.5)
	# Keep the bearing continuous rather than jumping by a full turn.
	bearing += wrapf(rad_to_deg(atan2(here.x, -here.z)) - bearing, -180.0, 180.0)
	if _running:
		return
	match _after_run:
		"peek":
			# Settled behind cover: from here on it peeks out and back.
			_peek_center = bearing - wrapf(bearing - float(_run_cover.bearing), -180.0, 180.0)
			_peek_side = _run_cover.side
			_peek_spot = _run_cover.spot
			_peek_speed = PEEK_WALK_SPEED
			_peeks = true
			_peek_phase = "hidden"
			_peek_wait = randf_range(0.4, 1.0)
			pattern = "strafe"
			if randf() < 0.5:
				stance = "crouch"
		"hold":
			pattern = "hold"
		_:
			pattern = "strafe"


## An enemy that peeks: out from cover for a moment, back behind it, out
## again, sometimes coming back crouched.
func _move_peeking(delta: float) -> void:
	var off := (bearing - _peek_center) * _peek_side
	match _peek_phase:
		"exposed":
			_peek_wait -= delta
			if _peek_wait <= 0.0:
				if move_to_cover.is_empty():
					_peek_phase = "back"
				else:
					# Break from this cover and run to the next.
					var next := move_to_cover
					move_to_cover = {}
					_peek_side = 0.0
					_peek_phase = ""
					run_to(tucked_point(next), "peek", next)
		"back":
			bearing -= _peek_side * rad_to_deg(_peek_speed * delta / distance)
			# Far enough in that none of it shows.
			var tucked := float(_peek_spot.emerge_off) \
				- (float(_peek_spot.min_off) - float(_peek_spot.emerge_off)) * 0.7
			if off <= tucked:
				_peek_phase = "hidden"
				_peek_wait = randf_range(0.4, 0.9)
				if stance == "stand" or stance == "crouch":
					stance = "crouch" if randf() < 0.5 else "stand"
		"hidden":
			_peek_wait -= delta
			if _peek_wait <= 0.0:
				_stepping_out = true


func update(delta: float) -> void:
	_prev_bearing = bearing
	_prev_distance = distance
	if _stepping_out:
		# Walk out past the edge of the cover before doing anything else.
		bearing += _peek_side * rad_to_deg(_peek_speed * delta / distance)
		if (bearing - _peek_center) * _peek_side >= float(_peek_spot.clear_off):
			_stepping_out = false
			_strafe_dir = _peek_side
			if _peeks:
				_peek_phase = "exposed"
				_peek_wait = randf_range(0.7, 1.4)
	elif _lying > 0.0:
		_running = false
	elif _running:
		_move_running(delta)
	elif _peek_phase != "":
		_move_peeking(delta)
	else:
		_move_in_open(delta)

	# How it actually moved, in its own terms: to its left, and toward the
	# player. This is what picks the animation.
	if delta > 0.0:
		_motion = Vector2(deg_to_rad(bearing - _prev_bearing) * distance,
			_prev_distance - distance) / delta
	else:
		_motion = Vector2.ZERO

	if _dropping:
		_lying = minf(_lying + delta / DROP_TIME, 1.0)

	_jump_height = 0.0
	if stance == "jump":
		if _jump_t < 0.0:
			_next_jump -= delta
			if _next_jump <= 0.0:
				_jump_t = 0.0
		else:
			_jump_t += delta
			var u := _jump_t / JUMP_AIR_TIME
			if u >= 1.0:
				_jump_t = -1.0
				_next_jump = randf_range(0.3, 0.9)
			else:
				_jump_height = 4.0 * JUMP_APEX * u * (1.0 - u)

	var base: Dictionary = CROUCHED if stance == "crouch" else UPRIGHT
	body_top = lerpf(base.body_top, LYING.body_top, _lying)
	head_height = lerpf(base.head, LYING.head, _lying)

	var b := deg_to_rad(bearing)
	position = Vector3(sin(b) * distance, base_height + _jump_height, -cos(b) * distance)
	if _platform:
		_platform.position.y = -base_height / 2.0 - _jump_height
	# Local +Z faces the player at the origin.
	rotation.y = atan2(-position.x, -position.z)
	_body.scale.y = body_top / MESH_BODY_HEIGHT
	_body.position.y = body_top / 2.0
	_head.position = Vector3(0, head_height, HEAD_FORWARD_WHEN_LYING * _lying)
	_update_figure()


func head_center() -> Vector3:
	var toward_player := Vector3(-position.x, 0, -position.z).normalized()
	return position + Vector3(0, head_height, 0) + toward_player * HEAD_FORWARD_WHEN_LYING * _lying


func aim_point() -> Vector3:
	return position + Vector3(0, body_top * 0.75, 0)


## Aim point if the target were standing still on its base (ignores a jump).
func resting_aim_point() -> Vector3:
	return Vector3(position.x, base_height + body_top * 0.75, position.z)


## Where a shot lands: Geo.HEAD, BODY (the torso), ARM, LEG or MISS. When
## the animated figure is on screen the regions follow its limbs; otherwise
## the plain upright shape is used.
func hit_test(origin: Vector3, dir: Vector3) -> int:
	if _figure_in_use():
		return _model.hit(transform, origin, dir)
	return Geo.ray_hit(origin, dir, position, body_top, head_center())


func _figure_in_use() -> bool:
	return _model != null and _model.visible and is_inside_tree()


## The hit regions as they are now, for drawing them while checking.
func hit_regions() -> Array:
	return _model.regions(transform) if _figure_in_use() else []
