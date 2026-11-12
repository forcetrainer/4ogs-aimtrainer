extends RefCounted
## Hit test for a humanoid target, done analytically so a shot is judged
## against the exact aim direction with no physics-tick delay.
## feet: world position of the target's feet. body_top: height of the torso
## above the feet in the current stance. head_center: world position of the head.
## Returns MISS, BODY or HEAD.

enum { MISS, BODY, HEAD }

const BODY_RADIUS := 0.25
const HEAD_RADIUS := 0.12


static func ray_hit(origin: Vector3, dir: Vector3, feet: Vector3, body_top: float,
		head_center: Vector3) -> int:
	if _hits_sphere(origin, dir, head_center, HEAD_RADIUS):
		return HEAD
	if _hits_upright_cylinder(origin, dir, feet, BODY_RADIUS, body_top):
		return BODY
	return MISS


static func _hits_sphere(origin: Vector3, dir: Vector3, center: Vector3, radius: float) -> bool:
	var oc := origin - center
	var b := oc.dot(dir)
	var disc := b * b - (oc.dot(oc) - radius * radius)
	return disc >= 0.0 and (-b + sqrt(disc)) > 0.0


static func _hits_upright_cylinder(origin: Vector3, dir: Vector3, base: Vector3,
		radius: float, height: float) -> bool:
	var o := Vector2(origin.x - base.x, origin.z - base.z)
	var d := Vector2(dir.x, dir.z)
	var a := d.dot(d)
	if a < 1e-12:
		return false
	var b := o.dot(d)
	var disc := b * b - a * (o.dot(o) - radius * radius)
	if disc < 0.0:
		return false
	var t := (-b - sqrt(disc)) / a
	if t < 0.0:
		return false
	var y := origin.y + t * dir.y
	return y >= base.y and y <= base.y + height
