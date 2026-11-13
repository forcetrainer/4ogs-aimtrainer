extends SceneTree
## Prints what is inside each character file: meshes, skeleton and animations.
## Run: godot --headless --path game --script res://tests/tools_inspect_enemy.gd

const DIR := "res://assets/enemy"


func _init() -> void:
	for f in DirAccess.get_files_at(DIR):
		if not f.ends_with(".fbx"):
			continue
		var scene: PackedScene = load("%s/%s" % [DIR, f])
		if scene == null:
			print("ENEMY %s: failed to load" % f)
			continue
		var root: Node = scene.instantiate()
		print("ENEMY %s" % f)
		_walk(root, 1)
		root.free()
	quit()


func _walk(node: Node, depth: int) -> void:
	var pad := "  ".repeat(depth)
	if node is MeshInstance3D:
		var mi := node as MeshInstance3D
		var box := mi.get_aabb()
		print("ENEMY %smesh %s  size %.2f x %.2f x %.2f  surfaces %d" % [
			pad, mi.name, box.size.x, box.size.y, box.size.z, mi.mesh.get_surface_count()])
	elif node is Skeleton3D:
		var sk := node as Skeleton3D
		print("ENEMY %sskeleton %s  bones %d  scale %s  first bone %s" % [
			pad, sk.name, sk.get_bone_count(), str(sk.scale), sk.get_bone_name(0)])
	elif node is AnimationPlayer:
		var ap := node as AnimationPlayer
		for a in ap.get_animation_list():
			var anim := ap.get_animation(a)
			print("ENEMY %sanimation '%s'  %.2f s  %d tracks  loop %d" % [
				pad, a, anim.length, anim.get_track_count(), anim.loop_mode])
	elif depth <= 2:
		print("ENEMY %s%s (%s)" % [pad, node.name, node.get_class()])
	for child: Node in node.get_children():
		_walk(child, depth + 1)
