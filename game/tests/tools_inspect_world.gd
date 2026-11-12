extends SceneTree
## Prints the size and parts of every scenery model, for laying out the yard.
## Run: godot --headless --path game --script res://tests/tools_inspect_world.gd

const DIR := "res://assets/world/models"


func _init() -> void:
	for id: String in DirAccess.get_directories_at(DIR):
		var path := "%s/%s/%s.gltf" % [DIR, id, id]
		var scene: PackedScene = load(path)
		if scene == null:
			print("%s: FAILED TO LOAD" % id)
			continue
		var root: Node3D = scene.instantiate()
		print("%s:" % id)
		_walk(root, Transform3D.IDENTITY, 1)
		root.free()
	quit()


func _walk(node: Node, parent_xf: Transform3D, depth: int) -> void:
	var xf := parent_xf
	if node is Node3D:
		xf = parent_xf * (node as Node3D).transform
	if node is MeshInstance3D:
		var box: AABB = xf * (node as MeshInstance3D).get_aabb()
		print("%s%s  size %.2f x %.2f x %.2f  min (%.2f, %.2f, %.2f)" % [
			"  ".repeat(depth), node.name, box.size.x, box.size.y, box.size.z,
			box.position.x, box.position.y, box.position.z])
	for child: Node in node.get_children():
		_walk(child, xf, depth + 1)
