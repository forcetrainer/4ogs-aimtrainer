extends RefCounted
## The scrap-built industrial structure from Oleg Ushenok's "FREE Post
## Apocalypse Survivor Environment Kitbash set" (Fab, Standard License), and
## the loose pieces taken out of it.
##
## The file holds one building made of 330 parts that all share a single
## set of textures. The file does not link to the textures, so the material
## is put together here. The parts are only numbered, so the ones worth
## using on their own are named below; the numbers are positions in the
## catalogue made by tests/kit_sheets.gd (pictures of every part).
##
## The model is about 2.4 times life size (a gas cylinder in it is 3.6 m
## tall), so everything is scaled by SCALE.

const PATH := "res://assets/kit/kitbash.fbx"
const TEXTURES := "res://assets/kit/Post_apocalypse_city_"
const SCALE := 0.42

## Parts used on their own, with their size after scaling where the yard
## needs it.
const DUMPSTER := 0      # 1.97 wide, 1.45 high, 1.20 deep
const TANK := 1          # 2.54 across, 3.50 high
const RACK := 33         # shelving full of clutter: 2.55 wide, 2.63 high, 0.79 deep
const BARRELS := 36      # barrels under a tarpaulin: 1.86 wide, 1.10 high, 1.59 deep
const PLATE := 229       # riveted steel plate
const PLATE_WIDTH := 1.56
const PLATE_HEIGHT := 1.29
const BARRIER := 240     # concrete road barrier
const BARRIER_LENGTH := 2.64
const POST := 274        # bolted steel post
const BEAM := 49         # upright I-beam, 2.68 high
const WALKWAY := 172     # railed walkway: 1.37 wide, 4.12 long
const LADDER := 218      # 3.40 high

static var _material: StandardMaterial3D
static var _parts: Array = []


static func available() -> bool:
	return ResourceLoader.exists(PATH)


static func material() -> StandardMaterial3D:
	if _material:
		return _material
	var mat := StandardMaterial3D.new()
	mat.albedo_texture = load(TEXTURES + "color_dark.png")
	mat.metallic = 1.0
	mat.metallic_texture = load(TEXTURES + "metalness.png")
	mat.roughness_texture = load(TEXTURES + "roughness.png")
	mat.normal_enabled = true
	mat.normal_texture = load(TEXTURES + "normal.png")
	# Mesh panels and gratings are flat sheets with holes cut by this map.
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	mat.alpha_scissor_threshold = 0.5
	mat.alpha_antialiasing_mode = BaseMaterial3D.ALPHA_ANTIALIASING_ALPHA_TO_COVERAGE
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	_material = mat
	return mat


## The whole building at life size, standing on the ground with its middle
## at the origin. Empty if the kit files are not installed.
static func building() -> Node3D:
	var holder := Node3D.new()
	if not available():
		return holder
	var scene: Node3D = (load(PATH) as PackedScene).instantiate()
	_apply(scene, material())
	holder.add_child(scene)
	var box := bounds(holder)
	scene.position -= Vector3(box.get_center().x, box.position.y, box.get_center().z)
	holder.scale = Vector3.ONE * SCALE
	return holder


## One part of the building on its own, at life size, standing on the
## ground with its middle at the origin and facing the way it does in the
## building. Empty if the kit files are not installed.
static func part(index: int) -> Node3D:
	var holder := Node3D.new()
	_load_parts()
	if index < 0 or index >= _parts.size():
		return holder
	var entry: Dictionary = _parts[index]
	var mesh := MeshInstance3D.new()
	mesh.mesh = entry.mesh
	mesh.material_override = material()
	var box: AABB = entry.box
	mesh.transform = Transform3D(Basis.IDENTITY,
		-Vector3(box.get_center().x, box.position.y, box.get_center().z)) * entry.xf
	holder.add_child(mesh)
	holder.scale = Vector3.ONE * SCALE
	return holder


## Size of a part at life size: width, height, depth.
static func part_size(index: int) -> Vector3:
	_load_parts()
	if index < 0 or index >= _parts.size():
		return Vector3.ZERO
	return (_parts[index].box as AABB).size * SCALE


static func _load_parts() -> void:
	if not _parts.is_empty() or not available():
		return
	var scene: Node3D = (load(PATH) as PackedScene).instantiate()
	_collect(scene, Transform3D.IDENTITY)
	scene.free()


static func _collect(node: Node, parent_xf: Transform3D) -> void:
	var xf := parent_xf
	if node is Node3D:
		xf = parent_xf * (node as Node3D).transform
	if node is MeshInstance3D:
		var mi := node as MeshInstance3D
		_parts.append({"mesh": mi.mesh, "xf": xf, "box": xf * mi.get_aabb()})
	for child: Node in node.get_children():
		_collect(child, xf)


static func _apply(node: Node, mat: Material) -> void:
	if node is MeshInstance3D:
		(node as MeshInstance3D).material_override = mat
	for child: Node in node.get_children():
		_apply(child, mat)


## The box round everything under a node, in that node's own space.
static func bounds(node: Node3D) -> AABB:
	var state := {"box": AABB(), "first": true}
	for child: Node in node.get_children():
		_grow(child, Transform3D.IDENTITY, state)
	return state.box


static func _grow(node: Node, parent_xf: Transform3D, state: Dictionary) -> void:
	var xf := parent_xf
	if node is Node3D:
		xf = parent_xf * (node as Node3D).transform
	if node is MeshInstance3D:
		var box: AABB = xf * (node as MeshInstance3D).get_aabb()
		state.box = box if state.first else (state.box as AABB).merge(box)
		state.first = false
	for child: Node in node.get_children():
		_grow(child, xf, state)
