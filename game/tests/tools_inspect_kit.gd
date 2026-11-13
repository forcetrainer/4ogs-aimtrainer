extends SceneTree
## Lists the parts of the kit building with their sizes and positions.
## Run: godot --headless --path game --script res://tests/tools_inspect_kit.gd

const PATH := "res://assets/kit/kitbash.fbx"


func _init() -> void:
	var scene: PackedScene = load(PATH)
	if scene == null:
		print("KIT failed to load")
		quit(1)
		return
	var root: Node3D = scene.instantiate()
	var building := root.get_child(0)
	print("KIT %s has %d direct children" % [building.name, building.get_child_count()])
	for child: Node in building.get_children():
		if child is MeshInstance3D:
			var mi := child as MeshInstance3D
			var box: AABB = mi.transform * mi.get_aabb()
			var tris := 0
			for s in mi.mesh.get_surface_count():
				var arrays := mi.mesh.surface_get_arrays(s)
				var idx = arrays[Mesh.ARRAY_INDEX]
				tris += (idx.size() if idx != null else arrays[Mesh.ARRAY_VERTEX].size()) / 3
			var mat := mi.mesh.surface_get_material(0)
			print("KIT %-34s tris %6d size %5.1f x %5.1f x %5.1f  centre (%6.1f, %5.1f, %6.1f)  mat %s" % [
				mi.name, tris, box.size.x, box.size.y, box.size.z, box.get_center().x,
				box.get_center().y, box.get_center().z, mat.resource_name if mat else "none"])
		else:
			print("KIT %s (%s, %d children)" % [child.name, child.get_class(), child.get_child_count()])
	root.free()
	quit()
