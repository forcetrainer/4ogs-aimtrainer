extends RefCounted
## Cover in the yard: where each piece is, and the geometry questions the
## drill asks about it (can the player see this point, does this shot hit
## cover first, where does an enemy stand to step out from behind it).
##
## Every piece is a box that faces the player's position at the middle of
## the yard, so its width runs across the player's view and its depth runs
## away from them. A piece is a Dictionary:
##   kind      "wall", "crates", "barriers" or "car"
##   bearing   degrees clockwise from north (-Z), as seen from the middle
##   distance  metres from the middle to the centre of the box
##   half      half its width (across), height and depth
##   tall      true if a standing enemy is fully hidden behind it

## Half sizes for each kind: across, up, deep.
const KINDS := {
	"wall": {"half": Vector3(1.7, 1.2, 0.18), "tall": true},
	"crates": {"half": Vector3(1.26, 1.18, 0.54), "tall": true},
	"barriers": {"half": Vector3(2.4, 0.42, 0.32), "tall": false},
	"car": {"half": Vector3(2.2, 0.65, 0.9), "tall": false},
}
## Where the pieces stand: bearing, distance, kind.
const LAYOUT := [
	[25.0, 17.0, "wall"], [150.0, 21.0, "wall"], [245.0, 15.0, "wall"], [318.0, 26.0, "wall"],
	[338.0, 18.0, "wall"], [100.0, 27.0, "wall"], [218.0, 28.0, "wall"],
	[80.0, 24.0, "crates"], [200.0, 19.0, "crates"],
	[110.0, 13.0, "barriers"], [285.0, 22.0, "barriers"], [352.0, 30.0, "barriers"],
	[170.0, 29.0, "car"], [52.0, 31.0, "car"],
]
## How far behind a piece an enemy stands, measured from its back face.
const STAND_BEHIND := 0.7
const BODY_RADIUS := 0.25


static func layout() -> Array:
	var pieces := []
	for row: Array in LAYOUT:
		var kind: Dictionary = KINDS[row[2]]
		pieces.append({"kind": row[2], "bearing": row[0], "distance": row[1],
			"half": kind.half, "tall": kind.tall})
	return pieces


## Unit vectors for a piece: `away` points from the middle out through the
## piece, `across` points to the right as the player faces it.
static func away(piece: Dictionary) -> Vector3:
	var b := deg_to_rad(piece.bearing)
	return Vector3(sin(b), 0.0, -cos(b))


static func across(piece: Dictionary) -> Vector3:
	var b := deg_to_rad(piece.bearing)
	return Vector3(cos(b), 0.0, sin(b))


## Middle of the box.
static func center(piece: Dictionary) -> Vector3:
	return away(piece) * piece.distance + Vector3(0.0, piece.half.y, 0.0)


## How far along a ray the nearest piece is hit, or INF if it hits none.
## `dir` must be a unit vector.
static func ray_distance(pieces: Array, origin: Vector3, dir: Vector3) -> float:
	var nearest := INF
	for piece: Dictionary in pieces:
		var c := center(piece)
		var ax := across(piece)
		var aw := away(piece)
		var rel := origin - c
		var o := Vector3(rel.dot(ax), rel.y, rel.dot(aw))
		var d := Vector3(dir.dot(ax), dir.y, dir.dot(aw))
		var half: Vector3 = piece.half
		var t_in := 0.0
		var t_out := INF
		var miss := false
		for axis in 3:
			if absf(d[axis]) < 1e-9:
				if absf(o[axis]) > half[axis]:
					miss = true
					break
				continue
			var t1 := (-half[axis] - o[axis]) / d[axis]
			var t2 := (half[axis] - o[axis]) / d[axis]
			t_in = maxf(t_in, minf(t1, t2))
			t_out = minf(t_out, maxf(t1, t2))
			if t_in > t_out:
				miss = true
				break
		if not miss:
			nearest = minf(nearest, t_in)
	return nearest


## True if cover stands between two points.
static func blocked(pieces: Array, from: Vector3, to: Vector3) -> bool:
	var span := to - from
	var length := span.length()
	if length < 1e-6:
		return false
	return ray_distance(pieces, from, span / length) < length - 0.05


## True if a point on the ground is inside a piece, or within `margin` of it.
static func inside(pieces: Array, point: Vector3, margin: float) -> bool:
	for piece: Dictionary in pieces:
		var rel := point - center(piece)
		if absf(rel.dot(across(piece))) <= piece.half.x + margin \
				and absf(rel.dot(away(piece))) <= piece.half.z + margin:
			return true
	return false


## How an enemy steps out from behind a tall piece on one side (-1 = the
## player's left, +1 = right). It stands at `distance` from the middle and
## moves by changing bearing. Offsets are degrees from the piece's bearing
## toward that side:
##   hidden_off  where it waits, out of sight
##   emerge_off  where its edge first shows
##   min_off     the closest it comes back in, with its whole body showing
##   clear_off   where it stops stepping out and starts moving freely
static func peek(piece: Dictionary, _side: float) -> Dictionary:
	var stand: float = piece.distance + piece.half.z + STAND_BEHIND
	# The edge of the piece as the player sees it, in degrees off its centre.
	var edge := rad_to_deg(atan(piece.half.x / (piece.distance - piece.half.z)))
	var body := rad_to_deg(atan(BODY_RADIUS / stand))
	return {
		"distance": stand,
		"hidden_off": edge - body * 2.4,
		"emerge_off": edge - body,
		"min_off": edge + body * 1.2,
		"clear_off": edge + body * 2.4,
	}
