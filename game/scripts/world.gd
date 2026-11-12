extends RefCounted
## The place the drill happens in: sky, sun, ground and distant scenery.
## Shared by the drill and the menu backdrop so both show the same world.

const Lighting = preload("res://scripts/lighting.gd")


## Adds the world to parent. Returns the direction toward the sun.
static func build(parent: Node) -> Vector3:
	var sun_dir := Lighting.build(parent)

	var ground := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(200, 200)
	ground.mesh = plane
	ground.material_override = _flat_material(Color(0.3, 0.31, 0.28))
	parent.add_child(ground)

	# Distant blocks give the eye a sense of rotation; targets always spawn nearer.
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	for i in 28:
		var angle := rng.randf_range(0.0, TAU)
		var dist := rng.randf_range(48.0, 85.0)
		var block := MeshInstance3D.new()
		var box := BoxMesh.new()
		box.size = Vector3(rng.randf_range(3, 9), rng.randf_range(2.5, 9), rng.randf_range(3, 9))
		block.mesh = box
		var shade := rng.randf_range(0.34, 0.52)
		block.material_override = _flat_material(Color(shade, shade * 0.97, shade * 0.9))
		block.position = Vector3(sin(angle) * dist, box.size.y / 2.0, -cos(angle) * dist)
		parent.add_child(block)
	return sun_dir


static func _flat_material(color: Color) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.9
	return mat
