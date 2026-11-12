extends Node3D
## The first-person weapon as drawn on screen: its pose between hip and the
## chosen sight, the optic toggle, muzzle flash, recoil kick and sway. All of
## this is visual only; the true aim point never moves with it.
##
## Add this node under the camera, then call setup(). The node itself is the
## "lens": it is stretched sideways and upward in camera space so the weapon
## is drawn exactly as a camera with the weapon's own field of view would.

const Viewmodel = preload("res://scripts/viewmodel.gd")
const AimState = preload("res://scripts/aim_state.gd")

const KICK_BACK_M := 0.012
const KICK_UP_DEG := 0.7
const KICK_DECAY_PER_S := 14.0
const KICK_PER_SHOT := 1.0
const KICK_MAX := 1.6
const SWAY_M_PER_DEG := 0.0012
const SWAY_MAX_M := 0.02
const FLASH_USEC := 35_000

var gun: Node3D
var optic: Node3D
var muzzle_flash: MeshInstance3D

var _hip_pos := Vector3.ZERO
var _hip_rot := Vector3.ZERO
var _irons_pos := Vector3.ZERO
var _optic_pos := Vector3.ZERO
var _irons_pitch := 0.0
var _tan_half_fov := 0.466
var _gun_mesh: MeshInstance3D
var _mount_surface := -1
var _kick := 0.0
var _sway := Vector2.ZERO
var _last_yaw := 0.0
var _last_pitch := 0.0
var _flash_until_usec := 0


func setup(weapon: Dictionary, optic_on: bool) -> void:
	var built := Viewmodel.build(weapon)
	gun = built.root
	optic = built.optic
	muzzle_flash = built.flash
	_hip_pos = built.hip
	_hip_rot = built.hip_rotation
	_irons_pos = built.irons
	_optic_pos = built.optic_ads
	_irons_pitch = built.irons_pitch
	_gun_mesh = built.gun_mesh
	_mount_surface = built.mount_surface
	_tan_half_fov = tan(deg_to_rad(built.fov_vertical) / 2.0)
	add_child(gun)
	set_optic(optic_on)


func has_optic() -> bool:
	return optic != null and optic.visible


func sight_name() -> String:
	return "optic" if has_optic() else "irons"


func set_optic(on: bool) -> void:
	if optic:
		optic.visible = on
	Viewmodel.set_mount_visible(_gun_mesh, _mount_surface, on)


## A shot was fired: flash the muzzle and kick the weapon.
func fired(now_usec: int) -> void:
	_flash_until_usec = now_usec + FLASH_USEC
	_kick = minf(_kick + KICK_PER_SHOT, KICK_MAX)


## Place the weapon between hip and the chosen sight, then add recoil kick
## and a little lag behind the mouse. Both shrink while aiming so the sight
## stays close to the true aim point. `aimed` runs from 0 (hip) to 1 (sight
## fully raised); `camera_fov_deg` is the camera's vertical field of view.
func update(delta: float, now_usec: int, aim: AimState, aimed: float,
		camera_fov_deg: float) -> void:
	var ads_pos := _optic_pos if has_optic() else _irons_pos
	var loose := lerpf(1.0, 0.25, aimed)

	_kick = maxf(_kick - _kick * KICK_DECAY_PER_S * delta, 0.0)
	var turn := Vector2(aim.yaw_deg - _last_yaw, aim.pitch_deg - _last_pitch)
	_last_yaw = aim.yaw_deg
	_last_pitch = aim.pitch_deg
	var want := (Vector2(-turn.x, turn.y) * SWAY_M_PER_DEG / maxf(delta, 0.001) * 0.05) \
		.limit_length(SWAY_MAX_M)
	_sway = _sway.lerp(want, minf(delta * 10.0, 1.0))

	# Iron sights need the gun tipped up a touch, about the eye, so the front
	# post sits on the aim point.
	var tilt := 0.0 if has_optic() else _irons_pitch
	var aimed_pos := Basis(Vector3.RIGHT, deg_to_rad(tilt)) * ads_pos
	gun.position = _hip_pos.lerp(aimed_pos, aimed) \
		+ Vector3(_sway.x, _sway.y, _kick * KICK_BACK_M) * loose
	gun.rotation_degrees = _hip_rot.lerp(Vector3(tilt, 0, 0), aimed) \
		+ Vector3(_kick * KICK_UP_DEG * loose, 0, 0)
	var lens := tan(deg_to_rad(camera_fov_deg) / 2.0) / _tan_half_fov
	scale = Vector3(lens, lens, 1.0)
	muzzle_flash.visible = now_usec < _flash_until_usec
