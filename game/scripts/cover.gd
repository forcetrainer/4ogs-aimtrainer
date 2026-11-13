extends RefCounted
## Cover in the yard: where each piece is, and the geometry questions the
## drill asks about it (can the player see this point, does this shot hit
## cover first, where does an enemy stand to step out from behind it).
##
## Every piece is a box that faces the player's position at the middle of
## the yard, so its width runs across the player's view and its depth runs
## away from them. A piece is a Dictionary:
##   kind      "plates", "tank", "rack", "tower" (tall), "barriers", "dumpster", "barrels" (low)
##   bearing   degrees clockwise from north (-Z), as seen from the middle
##   distance  metres from the middle to the centre of the box
##   half      half its width (across), height and depth
##   tall      true if a standing enemy is fully hidden behind it
##   lift      height of the bottom of the box above the ground (0 for most)
##   foot      half the width and depth of ground the piece takes up
##
## A "tower" is a raised platform with a steel screen on it. Its box is the
## screen, up in the air; an enemy stands on the platform behind the screen
## and steps out along it. That is how enemies above the player appear.

## Half sizes for each kind: across, up, deep.
const KINDS := {
	"plates": {"half": Vector3(1.6, 1.29, 0.12), "tall": true},
	"tank": {"half": Vector3(1.27, 1.75, 1.27), "tall": true},
	"rack": {"half": Vector3(1.27, 1.31, 0.4), "tall": true},
	"barriers": {"half": Vector3(2.64, 0.44, 0.35), "tall": false},
	"dumpster": {"half": Vector3(0.98, 0.72, 0.6), "tall": false},
	"barrels": {"half": Vector3(0.93, 0.55, 0.8), "tall": false},
	"tower": {"half": Vector3(0.78, 1.29, 0.12), "tall": true, "lift": TOWER_DECK,
		"foot": Vector3(2.3, 0.0, 1.3)},
}
## Where the pieces stand: bearing, distance, kind.
const LAYOUT := [
	[25.0, 17.0, "plates"], [150.0, 21.0, "tank"], [245.0, 15.0, "tower"], [318.0, 26.0, "rack"],
	[338.0, 18.0, "tank"], [100.0, 27.0, "tower"], [218.0, 28.0, "rack"],
	[80.0, 24.0, "tank"], [200.0, 19.0, "plates"],
	[110.0, 13.0, "barriers"], [285.0, 22.0, "barriers"], [352.0, 30.0, "barrels"],
	[170.0, 29.0, "dumpster"], [52.0, 31.0, "dumpster"],
]
## How far behind a piece an enemy stands, measured from its back face.
const STAND_BEHIND := 0.7
## Height of a tower platform above the ground, in metres.
const TOWER_DECK := 2.68
const BODY_RADIUS := 0.25
## How far an enemy walks behind cover before reaching its edge, in metres
## (less if the piece is too narrow).
const WALK_IN := 1.4


static func layout() -> Array:
	var pieces := []
	for row: Array in LAYOUT:
		_add(pieces, row[2], row[0], row[1])
	return pieces


## Nearest and furthest a generated piece stands from the middle.
const NEAR := 12.0
const FAR := 31.0
## Generated pieces keep at least this many degrees apart as the player
## sees them, so none hides behind another and sight lines stay open.
const MIN_GAP_DEG := 15.0


## A layout made from a seed: the same seed always gives the same arena.
## The rules: tall pieces are spread all the way round, one to a sector, so
## an enemy can step out in any direction; low pieces fill gaps; distances
## are mixed; and every piece is clear of the others as the player sees it.
static func generate(arena_seed: int) -> Array:
	var rng := RandomNumberGenerator.new()
	rng.seed = arena_seed
	var pieces := []
	var tall_count := rng.randi_range(6, 8)
	var sector := 360.0 / tall_count
	var turn := rng.randf_range(0.0, 360.0)
	for i in tall_count:
		# Keep clear of the sector's edges so neighbours cannot crowd.
		var bearing := turn + (i + rng.randf_range(0.3, 0.7)) * sector
		_add(pieces, ["plates", "plates", "tank", "rack", "tower", "tower"][rng.randi_range(0, 5)],
			bearing,
			rng.randf_range(NEAR + 1.0, FAR - 2.0))
	var low_count := rng.randi_range(3, 5)
	var tries := 0
	while low_count > 0 and tries < 200:
		tries += 1
		var bearing := rng.randf_range(0.0, 360.0)
		if _clear_of(pieces, bearing):
			_add(pieces, ["barriers", "barriers", "dumpster", "barrels"][rng.randi_range(0, 3)], bearing,
				rng.randf_range(NEAR, FAR))
			low_count -= 1
	return pieces


static func _add(pieces: Array, kind_name: String, bearing: float, distance: float) -> void:
	var kind: Dictionary = KINDS[kind_name]
	pieces.append({"kind": kind_name, "bearing": fposmod(bearing, 360.0), "distance": distance,
		"half": kind.half, "tall": kind.tall, "lift": float(kind.get("lift", 0.0)),
		"foot": kind.get("foot", kind.half)})


static func _clear_of(pieces: Array, bearing: float) -> bool:
	for piece: Dictionary in pieces:
		if absf(wrapf(bearing - piece.bearing, -180.0, 180.0)) < MIN_GAP_DEG:
			return false
	return true


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
	return away(piece) * piece.distance \
		+ Vector3(0.0, float(piece.get("lift", 0.0)) + piece.half.y, 0.0)


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
		var foot: Vector3 = piece.get("foot", piece.half)
		if absf(rel.dot(across(piece))) <= foot.x + margin \
				and absf(rel.dot(away(piece))) <= foot.z + margin:
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
		"stand_height": float(piece.get("lift", 0.0)),
		# It starts well back from the edge and walks out, so its footsteps
		# are heard for most of a second before it shows.
		"hidden_off": maxf(edge - body * 2.4 - rad_to_deg(atan(WALK_IN / stand)), 0.0),
		"emerge_off": edge - body,
		"min_off": edge + body * 1.2,
		"clear_off": edge + body * 2.4,
	}
