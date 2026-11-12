extends SceneTree
## Prints the node tree, mesh bounds and materials of the imported weapon models.
## Run: godot --headless --path game --script res://tests/inspect_models.gd

const MODELS := [
	"res://assets/weapons/mp5/source/SM_MP5.fbx",
	"res://assets/weapons/red_dot/crimson_trace_cts-1550_red_dot_sight.glb",
]


func _init() -> void:
	for path: String in MODELS:
		print("\n=== ", path)
		var scene: PackedScene = load(path)
		if scene == null:
			print("  FAILED TO LOAD")
			continue
		var root := scene.instantiate()
		_dump(root, 1, Transform3D.IDENTITY)
		root.free()
	quit()


func _dump(node: Node, depth: int, parent_xf: Transform3D) -> void:
	var pad := "  ".repeat(depth)
	var xf := parent_xf
	var line := "%s%s [%s]" % [pad, node.name, node.get_class()]
	if node is Node3D:
		xf = parent_xf * node.transform
		line += " pos=%s rot=%s scale=%s" % [node.position, node.rotation_degrees, node.scale]
	print(line)
	if node is MeshInstance3D and node.mesh:
		var box: AABB = xf * node.mesh.get_aabb()
		print("%s  bounds min=%s max=%s size=%s" % [pad, box.position, box.end, box.size])
		for i in node.mesh.get_surface_count():
			var mat: Material = node.get_active_material(i)
			var info := "none"
			if mat is BaseMaterial3D:
				info = "%s albedo_tex=%s normal=%s metallic=%.2f rough=%.2f transparency=%d" % [
					mat.resource_name, mat.albedo_texture != null, mat.normal_enabled,
					mat.metallic, mat.roughness, mat.transparency]
			print("%s  surface %d: %d verts, material %s" % [
				pad, i, node.mesh.surface_get_array_len(i), info])
	if node is AnimationPlayer:
		print("%s  animations: %s" % [pad, node.get_animation_list()])
	for child in node.get_children():
		_dump(child, depth + 1, xf)
