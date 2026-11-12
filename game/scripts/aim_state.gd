extends RefCounted
## View angles accumulated from raw mouse counts, kept in 64-bit floats and
## never read back from the camera node, so rounding cannot build up.

const MAX_PITCH := 89.0

var deg_per_count := 0.033
## Unwrapped: 720 means two full turns to the right.
var yaw_deg := 0.0
var pitch_deg := 0.0
var counts_x := 0.0
var counts_y := 0.0
## Total horizontal counts regardless of direction (hand travel).
var abs_counts_x := 0.0


func apply_counts(dx: float, dy: float) -> void:
	yaw_deg += dx * deg_per_count
	pitch_deg = clampf(pitch_deg - dy * deg_per_count, -MAX_PITCH, MAX_PITCH)
	counts_x += dx
	counts_y += dy
	abs_counts_x += absf(dx)


## Move the view by an angle that did not come from the mouse (recoil).
func add_degrees(yaw: float, pitch: float) -> void:
	yaw_deg += yaw
	pitch_deg = clampf(pitch_deg + pitch, -MAX_PITCH, MAX_PITCH)


## Unit vector the view is pointing along, optionally offset by an angle.
func direction(yaw_offset := 0.0, pitch_offset := 0.0) -> Vector3:
	var y := deg_to_rad(yaw_deg + yaw_offset)
	var p := deg_to_rad(pitch_deg + pitch_offset)
	return Vector3(sin(y) * cos(p), sin(p), -cos(y) * cos(p))


func reset() -> void:
	yaw_deg = 0.0
	pitch_deg = 0.0
	counts_x = 0.0
	counts_y = 0.0
	abs_counts_x = 0.0


## Euler rotation for a Godot camera (positive Y rotation turns left).
func camera_rotation() -> Vector3:
	return Vector3(deg_to_rad(pitch_deg), -deg_to_rad(fposmod(yaw_deg, 360.0)), 0.0)


## How many of a mouse movement's counts go toward a target that is
## `yaw_to` degrees to the right and `pitch_to` degrees above the crosshair
## (negative when the movement heads away). For a target roughly behind,
## turning either way is toward it.
static func counts_toward(dx: float, dy: float, yaw_to: float, pitch_to: float) -> float:
	if absf(yaw_to) > 120.0:
		return absf(dx)
	var to := Vector2(yaw_to, pitch_to)
	if to.length() < 1e-6:
		return 0.0
	return Vector2(dx, -dy).dot(to.normalized())
