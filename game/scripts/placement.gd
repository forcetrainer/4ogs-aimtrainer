extends RefCounted
## Where targets appear. On-screen positions are chosen in the player's own
## visual field (degrees of visual angle from the crosshair, set by monitor
## size and viewing distance, not game FOV) and then converted to a place in
## the world for the current view.

const Sens = preload("res://scripts/sens.gd")
const AimState = preload("res://scripts/aim_state.gd")
const Target = preload("res://scripts/target.gd")

## Where a drill asks for targets: rings of visual angle between the
## crosshair and the target as seen from the eye. "far" runs out to the edge
## of the screen.
const VISUAL_ZONES := {"center": [0.5, 5.0], "mid": [5.0, 10.0], "far": [10.0, 90.0]}
## Reporting bins. Vision falls off smoothly with no natural breakpoints, so
## on-screen results are grouped in log-spaced rings of visual angle and the
## exact angle and direction of every target are logged for curve fitting.
const ZONE_NAMES := {
	"0-2.5": "within 2.5 deg", "2.5-5": "2.5 to 5 deg", "5-10": "5 to 10 deg",
	"10-20": "10 to 20 deg", "20+": "beyond 20 deg",
	"offscreen": "just off screen", "behind": "behind you",
}
const MIN_DISTANCE := 10.0
const MAX_DISTANCE := 35.0
## The game FOV slider is horizontal at this shape of screen.
const FOV_ASPECT := 16.0 / 9.0


static func weighted_pick(weights: Dictionary) -> String:
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
static func screen_half_cm(diagonal_in: float, aspect: float) -> Vector2:
	var height := diagonal_in * 2.54 / sqrt(1.0 + aspect * aspect)
	return Vector2(height * aspect, height) / 2.0


## How far to each side of the crosshair the screen reaches in the player's
## vision, in degrees of visual angle.
static func screen_visual_half_deg(diagonal_in: float, view_distance_cm: float,
		aspect: float) -> Vector2:
	var half := screen_half_cm(diagonal_in, aspect)
	return Vector2(rad_to_deg(atan(half.x / view_distance_cm)),
		rad_to_deg(atan(half.y / view_distance_cm)))


static func ecc_bin(ecc: float) -> String:
	if ecc < 2.5:
		return "0-2.5"
	if ecc < 5.0:
		return "2.5-5"
	if ecc < 10.0:
		return "5-10"
	return "10-20" if ecc < 20.0 else "20+"


## Yaw offset for a zone outside the screen, measured against the current view.
static func off_screen_offset(zone: String, hfov: float) -> float:
	var half := hfov / 2.0
	var side := 1.0 if randf() < 0.5 else -1.0
	if zone == "behind":
		return side * randf_range(maxf(half + 60.0, 120.0), 180.0)
	return side * randf_range(half + 5.0, minf(half + 60.0, 175.0))


## Pick a zone and stance from a drill's weights and place one target.
## Returns bearing, distance, base (height of its feet), stance, zone (the
## reporting bin), in_view, and for on-screen targets the visual angle (ecc)
## and direction around the crosshair actually achieved (-1 when off screen).
static func place(drill: Dictionary, settings: Dictionary, aim: AimState, hfov: float,
		aspect: float, eye: Vector3) -> Dictionary:
	var zone := weighted_pick(drill.zones)
	var stance := weighted_pick(drill.stances)
	if VISUAL_ZONES.has(zone):
		var spot := on_screen(zone, stance, randf() < drill.vertical_chance,
			settings.monitor_diagonal_in, settings.view_distance_cm, aim, hfov, aspect, eye)
		spot["in_view"] = true
		return spot
	return {
		"bearing": aim.yaw_deg + off_screen_offset(zone, hfov), "base": 0.0, "stance": stance,
		"distance": randf_range(MIN_DISTANCE, MAX_DISTANCE), "ecc": -1.0,
		"direction": -1.0, "zone": zone, "in_view": false,
	}


## Choose where a target should appear on screen for a visual-field zone, then
## work out where in the world that is for the current view (so it holds at any
## game FOV and while aiming down sights). Level targets stand on the ground;
## vertical ones go on a ledge or close to the player's feet.
static func on_screen(zone: String, stance: String, vertical: bool, diagonal_in: float,
		eye_cm: float, aim: AimState, hfov: float, aspect: float, eye: Vector3) -> Dictionary:
	var half := screen_half_cm(diagonal_in, aspect)
	# Direction around the crosshair: mostly sideways, sometimes above or below.
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

	var tan_v := tan(deg_to_rad(Sens.horizontal_to_vertical_fov(hfov, FOV_ASPECT)) / 2.0)
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
		var ground_d := (eye.y - aim_h) / -dir.y * flat
		if ground_d < 4.0:
			dir.y = -dir.y  # too close to the feet; mirror it to above instead
		elif ground_d <= 60.0:
			distance = ground_d
	var base := 0.0
	if dir.y > 0.0:
		base = eye.y + distance * dir.y / flat - aim_h
		if base >= 1.0 and stance == "prone":
			stance = "crouch"  # a prone target on a ledge would be hidden by the ledge
			base = eye.y + distance * dir.y / flat - Target.aim_height_for(stance)
		# Only clearly raised targets get a platform; the rest stand on the ground.
		if base < 1.0:
			base = 0.0
	# Measure where the target really ended up in the player's vision.
	var b := deg_to_rad(bearing)
	var aim_point := Vector3(sin(b) * distance, base + Target.aim_height_for(stance),
		-cos(b) * distance)
	var cam := view.inverse() * (aim_point - eye)
	var on_screen_cm := Vector2(cam.x / -cam.z / (tan_v * aspect) * half.x,
		cam.y / -cam.z / tan_v * half.y)
	ecc = rad_to_deg(atan(on_screen_cm.length() / eye_cm))
	return {
		"bearing": bearing, "distance": distance, "base": base, "stance": stance, "ecc": ecc,
		"direction": rad_to_deg(on_screen_cm.angle()),
		"zone": ecc_bin(ecc),
	}
