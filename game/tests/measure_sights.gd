extends SceneTree
## Prints the bounds of each surface of the MP5 mesh and how many of its
## vertices fall inside the top rail's volume, to find which surface (if
## any) is the rail on its own.
## Run: godot --headless --path game --script res://tests/measure_sights.gd


func _init() -> void:
	var root: Node3D = load("res://assets/weapons/mp5/source/SM_MP5.fbx").instantiate()
	var mi: MeshInstance3D = root.get_child(0)
	var xf := mi.transform
	var rail := AABB(Vector3(-0.03, 0.160, 0.07), Vector3(0.06, 0.03, 0.12))
	for s in mi.mesh.get_surface_count():
		var verts: PackedVector3Array = mi.mesh.surface_get_arrays(s)[Mesh.ARRAY_VERTEX]
		var lo := Vector3.INF
		var hi := -Vector3.INF
		var in_rail := 0
		for v in verts:
			var p := xf * v
			lo = lo.min(p)
			hi = hi.max(p)
			if rail.has_point(p):
				in_rail += 1
		print("surface %d: %d verts, min %s max %s, %d inside rail volume" % [
			s, verts.size(), lo, hi, in_rail])
	root.free()
	quit()
