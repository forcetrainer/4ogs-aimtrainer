extends Node3D
## One enemy: where it is, how it stands and moves, and what can be hit.
## Stances: stand, crouch, prone, jump (keeps jumping), dropshot (drops prone
## the moment it is shot at). All sizes and timings are placeholders.

const Geo = preload("res://scripts/target_geometry.gd")

const STANCES := ["stand", "crouch", "prone", "jump", "dropshot"]
const UPRIGHT := {"body_top": 1.5, "head": 1.62}
const CROUCHED := {"body_top": 0.95, "head": 1.07}
const LYING := {"body_top": 0.35, "head": 0.22}
const HEAD_FORWARD_WHEN_LYING := 0.25
const DROP_TIME := 0.25
const JUMP_APEX := 0.9
const JUMP_AIR_TIME := 0.85
const MESH_BODY_HEIGHT := 1.5

var stance := "stand"
var bearing := 0.0
var distance := 20.0
var health := 150.0
var strafe_speed := 0.0
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


## Height above the feet that the player is expected to aim at, per stance.
static func aim_height_for(p_stance: String) -> float:
	var top: float = UPRIGHT.body_top
	if p_stance == "crouch":
		top = CROUCHED.body_top
	elif p_stance == "prone":
		top = LYING.body_top
	return top * 0.75


func setup(p_stance: String, p_bearing: float, p_distance: float, p_health: float,
		p_strafe_speed: float, p_base_height := 0.0) -> void:
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
	update(0.0)


## Start hidden behind a piece of cover and step out to one side. `spot`
## comes from Cover.peek(); `side` is -1 for the player's left, +1 for right.
## Call after setup().
func setup_peek(cover_bearing: float, side: float, spot: Dictionary, speed: float) -> void:
	_peek_center = cover_bearing
	_peek_side = side
	_peek_spot = spot
	_peek_speed = speed
	_stepping_out = true
	seen = false
	distance = spot.distance
	bearing = cover_bearing + side * float(spot.hidden_off)
	if stance == "prone":
		stance = "crouch"
		_lying = 0.0
	update(0.0)


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
	_strafe_dir = -_strafe_dir
	_flip_in = randf_range(0.4, 1.2)
	update(0.0)


## Called when the player fires at this target.
func shot_at() -> void:
	if stance == "dropshot":
		_dropping = true


func update(delta: float) -> void:
	var speed := strafe_speed
	if stance == "crouch":
		speed *= 0.5
	if _lying > 0.0:
		speed = 0.0
	_flip_in -= delta
	if _flip_in <= 0.0:
		_strafe_dir = -_strafe_dir
		_flip_in = randf_range(0.4, 1.2)
	_prev_bearing = bearing
	if _stepping_out:
		# Walk out past the edge of the cover before doing anything else.
		bearing += _peek_side * rad_to_deg(_peek_speed * delta / distance)
		if (bearing - _peek_center) * _peek_side >= float(_peek_spot.clear_off):
			_stepping_out = false
			_strafe_dir = _peek_side
	else:
		bearing += rad_to_deg(speed * _strafe_dir * delta / distance)
		if _peek_side != 0.0 \
				and (bearing - _peek_center) * _peek_side < float(_peek_spot.min_off):
			# Never slide back behind the cover it came from.
			bearing = _peek_center + _peek_side * float(_peek_spot.min_off)
			_strafe_dir = _peek_side

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
	_legs.visible = _lying > 0.5


func head_center() -> Vector3:
	var toward_player := Vector3(-position.x, 0, -position.z).normalized()
	return position + Vector3(0, head_height, 0) + toward_player * HEAD_FORWARD_WHEN_LYING * _lying


func aim_point() -> Vector3:
	return position + Vector3(0, body_top * 0.75, 0)


## Aim point if the target were standing still on its base (ignores a jump).
func resting_aim_point() -> Vector3:
	return Vector3(position.x, base_height + body_top * 0.75, position.z)


func hit_test(origin: Vector3, dir: Vector3) -> int:
	return Geo.ray_hit(origin, dir, position, body_top, head_center())
