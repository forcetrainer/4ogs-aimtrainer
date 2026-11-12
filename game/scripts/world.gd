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
	return sun_dir


## Draws the cover for one arena, where cover.gd says each piece is, so what
## the player sees matches what blocks sight and shots. Returns the node
## holding it all; free that node to clear the arena.
static func build_cover(parent: Node, pieces: Array) -> Node3D:
	var holder := Node3D.new()
	parent.add_child(holder)
	var wall := _surface("concrete_wall_006", Vector3(0.4, 0.4, 0.4), true)
	for piece: Dictionary in pieces:
		var ground := Cover.away(piece) * float(piece.distance)
		var across := Cover.across(piece)
		var away := Cover.away(piece)
		var yaw := -deg_to_rad(piece.bearing)
		match piece.kind:
			"wall":
				var slab := MeshInstance3D.new()
				var box := BoxMesh.new()
				box.size = piece.half * 2.0
				slab.mesh = box
				slab.material_override = wall
				slab.position = Cover.center(piece)
				slab.rotation.y = yaw
				holder.add_child(slab)
			"crates":
				for level in 5:
					for i in 2:
						for k in 2:
							_place(holder, "wooden_military_crate",
								ground + across * (i - 0.5) * 1.26 + away * (k - 0.5) * 0.54
									+ Vector3(0.0, level * 0.47, 0.0), yaw)
			"barriers":
				for i in 3:
					_place(holder, "concrete_road_barrier", ground + across * (i - 1.0) * 1.6, yaw)
			"car":
				_place(holder, "covered_car", ground, yaw + PI / 2.0)
	return holder


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
