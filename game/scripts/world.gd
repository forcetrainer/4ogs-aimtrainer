extends RefCounted
## The place the drill happens in: a fenced training yard under a
## photographed sky. Shared by the drill and the menu backdrop so both show
## the same world. Models and textures are from Poly Haven (CC0); see
## assets/world/LICENCE.txt.
##
## Targets appear anywhere within 35 m of the player and nothing yet checks
## whether scenery is in the way, so everything solid stays outside that
## circle. Cover inside it comes with cover-aware target placement.

const Lighting = preload("res://scripts/lighting.gd")
const Cover = preload("res://scripts/cover.gd")
const Kit = preload("res://scripts/kit.gd")

const MODELS := "res://assets/world/models"
const TEXTURES := "res://assets/world/textures"
## Half the side of the walled square, in metres.
const WALL_HALF := 46.0


## Adds the world to parent. Returns the direction toward the sun.
static func build(parent: Node) -> Vector3:
	var sun_dir := Lighting.build(parent)
	var rng := RandomNumberGenerator.new()
	rng.seed = 7

	var ground := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(400, 400)
	ground.mesh = plane
	var tarmac := _surface("worn_asphalt", Vector3(80, 80, 1), false)
	# The scan is a warm brown; pull it toward grey tarmac.
	tarmac.albedo_color = Color(0.56, 0.6, 0.66)
	ground.material_override = tarmac
	parent.add_child(ground)

	_buildings(parent, rng)
	_perimeter(parent)
	_props(parent, rng)
	# The scrap-built structure from the kit, one in each corner of the
	# yard, each turned a different way so they do not read as copies.
	var corner := WALL_HALF - 9.0
	var turns := [0.6, 2.4, 3.9, 5.3]
	for i in 4:
		var structure := Kit.building()
		structure.position = Basis(Vector3.UP, i * PI / 2.0) * Vector3(corner, 0.0, -corner)
		structure.rotation.y = turns[i]
		parent.add_child(structure)
	return sun_dir


## Draws the cover for one arena, where cover.gd says each piece is, so what
## the player sees matches what blocks sight and shots. Returns the node
## holding it all; free that node to clear the arena.
static func build_cover(parent: Node, pieces: Array) -> Node3D:
	var holder := Node3D.new()
	parent.add_child(holder)
	for piece: Dictionary in pieces:
		var ground := Cover.away(piece) * float(piece.distance)
		var across := Cover.across(piece)
		var yaw := -deg_to_rad(piece.bearing)
		if not Kit.available():
			# The kit's files are not shared with the project (its licence does
			# not allow it), so without them each piece is a plain concrete
			# block the size and place of the real thing.
			var block := MeshInstance3D.new()
			var shape := BoxMesh.new()
			shape.size = piece.half * 2.0
			block.mesh = shape
			block.material_override = _surface("concrete_wall_006", Vector3(0.4, 0.4, 0.4), true)
			block.position = Cover.center(piece)
			block.rotation.y = yaw
			holder.add_child(block)
			if piece.kind == "tower":
				var deck := MeshInstance3D.new()
				var slab := BoxMesh.new()
				slab.size = Vector3(4.1, 0.12, 1.4)
				deck.mesh = slab
				deck.material_override = block.material_override
				deck.position = ground + Cover.away(piece) * 0.45 + Vector3(0.0, Cover.TOWER_DECK - 0.06, 0.0)
				deck.rotation.y = yaw
				holder.add_child(deck)
			continue
		match piece.kind:
			"plates":
				# Riveted steel plates, two wide and two high, with a post at
				# each end.
				for level in 2:
					for i in 2:
						_kit(holder, Kit.PLATE, ground + across * (i - 0.5) * Kit.PLATE_WIDTH
							+ Vector3(0.0, level * Kit.PLATE_HEIGHT, 0.0), yaw)
				for end: float in [-1.0, 1.0]:
					_kit(holder, Kit.POST, ground + across * end * Kit.PLATE_WIDTH, yaw)
			"tower":
				# A platform on four legs with a ladder, and on it the steel
				# screen an enemy steps out from. The deck sits a little
				# behind the screen so there is room to stand.
				var back := Cover.away(piece) * 0.45
				var up := Vector3(0.0, Cover.TOWER_DECK, 0.0)
				for leg_across: float in [-1.85, 1.85]:
					for leg_back: float in [-0.5, 0.5]:
						_kit(holder, Kit.BEAM, ground + back + across * leg_across
							+ Cover.away(piece) * leg_back, yaw)
				_kit(holder, Kit.WALKWAY, ground + back + up - Vector3(0.0, 0.08, 0.0), yaw + PI / 2.0)
				_kit(holder, Kit.LADDER, ground + back + across * 2.25, yaw + PI / 2.0)
				for level in 2:
					_kit(holder, Kit.PLATE, ground + up + Vector3(0.0, level * Kit.PLATE_HEIGHT, 0.0), yaw)
			"tank":
				_kit(holder, Kit.TANK, ground, yaw)
			"rack":
				_kit(holder, Kit.RACK, ground, yaw)
			"barriers":
				for i in 2:
					_kit(holder, Kit.BARRIER, ground + across * (i - 0.5) * Kit.BARRIER_LENGTH, yaw)
			"dumpster":
				_kit(holder, Kit.DUMPSTER, ground, yaw)
			"barrels":
				_kit(holder, Kit.BARRELS, ground, yaw)
	return holder


static func _kit(parent: Node, index: int, at: Vector3, yaw: float) -> void:
	var node := Kit.part(index)
	node.position = at
	node.rotation.y = yaw
	parent.add_child(node)


## A material from a Poly Haven texture set. Triplanar mapping lets one
## texture cover boxes of any size without stretching.
static func _surface(id: String, scale: Vector3, triplanar: bool) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	var base := "%s/%s/%s" % [TEXTURES, id, id]
	if ResourceLoader.exists(base + "_diff_1k.jpg"):
		mat.albedo_texture = load(base + "_diff_1k.jpg")
		mat.normal_enabled = true
		mat.normal_texture = load(base + "_nor_gl_1k.jpg")
		mat.roughness_texture = load(base + "_rough_1k.jpg")
	else:
		mat.albedo_color = Color(0.4, 0.4, 0.38)
		mat.roughness = 0.9
	mat.uv1_scale = scale
	mat.uv1_triplanar = triplanar
	mat.uv1_world_triplanar = triplanar
	return mat


## Plain concrete blocks beyond the fence, standing in for buildings.
static func _buildings(parent: Node, rng: RandomNumberGenerator) -> void:
	var wall := _surface("concrete_wall_006", Vector3(0.25, 0.25, 0.25), true)
	for i in 30:
		var angle := rng.randf_range(0.0, TAU)
		var dist := rng.randf_range(62.0, 110.0)
		var block := MeshInstance3D.new()
		var box := BoxMesh.new()
		box.size = Vector3(rng.randf_range(8, 22), rng.randf_range(5, 16), rng.randf_range(8, 22))
		block.mesh = box
		block.material_override = wall
		block.position = Vector3(sin(angle) * dist, box.size.y / 2.0, -cos(angle) * dist)
		block.rotation.y = rng.randf_range(0.0, TAU)
		parent.add_child(block)


## A solid concrete wall round the yard. (A chain-link fence was tried
## first: at this distance its fine mesh shimmers and crawls as the view
## moves, which is distracting in a drill about spotting movement.)
static func _perimeter(parent: Node) -> void:
	var wall := _surface("concrete_wall_006", Vector3(0.3, 0.3, 0.3), true)
	for side in 4:
		var slab := MeshInstance3D.new()
		var box := BoxMesh.new()
		box.size = Vector3(WALL_HALF * 2.0 + 0.5, 3.2, 0.5)
		slab.mesh = box
		slab.material_override = wall
		var turn := Basis(Vector3.UP, side * PI / 2.0)
		slab.transform = Transform3D(turn, turn * Vector3(0.0, 1.6, -WALL_HALF))
		parent.add_child(slab)


static func _place(parent: Node, id: String, at: Vector3, yaw: float) -> void:
	var path := "%s/%s/%s.gltf" % [MODELS, id, id]
	if not ResourceLoader.exists(path):
		return
	var node: Node3D = (load(path) as PackedScene).instantiate()
	node.position = at
	node.rotation.y = yaw
	parent.add_child(node)


## Clusters of barriers, crates, barrels, tyres and parked cars just inside
## the fence, facing the middle of the yard.
static func _props(parent: Node, rng: RandomNumberGenerator) -> void:
	for cluster in 14:
		var angle := cluster * TAU / 14.0 + rng.randf_range(-0.12, 0.12)
		var dist := rng.randf_range(38.5, 43.0)
		var centre := Vector3(sin(angle) * dist, 0.0, -cos(angle) * dist)
		# Local axes: `across` runs side to side as seen from the middle.
		var across := Vector3(cos(angle), 0.0, sin(angle))
		var facing := -angle
		match cluster % 5:
			0:
				for i in 4:
					_place(parent, "concrete_road_barrier", centre + across * (i - 1.5) * 1.62,
						facing + rng.randf_range(-0.04, 0.04))
			1:
				for i in 3:
					_place(parent, "wooden_military_crate" if i != 1 else "old_military_crate",
						centre + across * (i - 1.0) * 1.3, facing + rng.randf_range(-0.5, 0.5))
				_place(parent, "barrel_03", centre + across * 2.4, rng.randf_range(0.0, TAU))
			2:
				_place(parent, "covered_car", centre, facing + PI / 2.0 + rng.randf_range(-0.2, 0.2))
				_place(parent, "old_tyre", centre + across * 2.2, rng.randf_range(0.0, TAU))
			3:
				for i in 3:
					_place(parent, "concrete_road_barrier_02", centre + across * (i - 1.0) * 1.64,
						facing + rng.randf_range(-0.04, 0.04))
				_place(parent, "Barrel_01", centre + across * 3.3, rng.randf_range(0.0, TAU))
			4:
				for i in 5:
					_place(parent, "barrel_03" if i % 2 == 0 else "Barrel_01",
						centre + across * (i - 2.0) * 0.75 + Vector3(0, 0, rng.randf_range(-0.3, 0.3)),
						rng.randf_range(0.0, TAU))
				_place(parent, "old_tyre", centre - across * 2.6, rng.randf_range(0.0, TAU))
