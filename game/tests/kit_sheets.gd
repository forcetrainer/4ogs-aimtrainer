extends Node3D
## Development aid: renders every part of the kit building on its own as a
## numbered thumbnail, and saves them as contact sheets of 60, so the parts
## (which are only numbered in the file) can be looked at and named.
## Also writes parts.csv with each part's size and position.
## Run: godot --path game res://tests/kit_sheets.tscn -- --out=<folder>

const Kit = preload("res://scripts/kit.gd")

const THUMB := 256
const COLUMNS := 10
const ROWS := 6


func _ready() -> void:
	var out := ""
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--out="):
			out = arg.trim_prefix("--out=")
	if out == "":
		print("SHEETS need --out=<folder>")
		get_tree().quit(1)
		return

	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.16, 0.17, 0.19)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.75, 0.77, 0.8)
	env.ambient_light_energy = 0.9
	var world_env := WorldEnvironment.new()
	world_env.environment = env
	add_child(world_env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-40, 35, 0)
	sun.light_energy = 1.4
	add_child(sun)

	var building := Kit.building()
	add_child(building)
	var parts: Array[MeshInstance3D] = []
	_collect(building, parts)
	for p in parts:
		p.visible = false

	var camera := Camera3D.new()
	camera.fov = 35
	add_child(camera)
	camera.make_current()

	var layer := CanvasLayer.new()
	add_child(layer)
	var tag := Label.new()
	tag.add_theme_font_size_override("font_size", 150)
	tag.add_theme_color_override("font_color", Color(1, 0.9, 0.2))
	tag.add_theme_color_override("font_outline_color", Color.BLACK)
	tag.add_theme_constant_override("outline_size", 24)
	layer.add_child(tag)

	var rows := ["index,name,width,height,depth,centre_x,base_y,centre_z,triangles"]
	var sheet: Image
	var per_sheet := COLUMNS * ROWS
	await get_tree().process_frame
	var screen := get_viewport().get_visible_rect().size
	var square := int(minf(screen.x, screen.y))
	# Put the number in the top-left corner of the square that gets kept.
	tag.position = Vector2((screen.x - square) / 2.0 + 20, 0)
	for i in parts.size():
		var part := parts[i]
		var box: AABB = part.global_transform * part.get_aabb()
		rows.append("%d,%s,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%d" % [
			i, part.name, box.size.x, box.size.y, box.size.z, box.get_center().x,
			box.position.y, box.get_center().z, _triangles(part.mesh)])
		part.visible = true
		var radius := maxf(box.size.length() / 2.0, 0.05)
		var from := box.get_center() + Vector3(0.8, 0.55, 1.0).normalized() \
			* radius / tan(deg_to_rad(camera.fov / 2.0)) * 1.15
		camera.look_at_from_position(from, box.get_center())
		tag.text = str(i)
		await RenderingServer.frame_post_draw
		await RenderingServer.frame_post_draw
		var shot := get_viewport().get_texture().get_image()
		shot = shot.get_region(Rect2i((shot.get_width() - square) / 2,
			(shot.get_height() - square) / 2, square, square))
		shot.resize(THUMB, THUMB, Image.INTERPOLATE_LANCZOS)
		shot.convert(Image.FORMAT_RGB8)
		part.visible = false
		var slot := i % per_sheet
		if slot == 0:
			sheet = Image.create(COLUMNS * THUMB, ROWS * THUMB, false, Image.FORMAT_RGB8)
		sheet.blit_rect(shot, Rect2i(0, 0, THUMB, THUMB),
			Vector2i(slot % COLUMNS * THUMB, slot / COLUMNS * THUMB))
		if slot == per_sheet - 1 or i == parts.size() - 1:
			sheet.save_png("%s/sheet_%d.png" % [out, i / per_sheet])
	var f := FileAccess.open("%s/parts.csv" % out, FileAccess.WRITE)
	f.store_string("\n".join(rows) + "\n")
	f.close()
	print("SHEETS wrote %d parts" % parts.size())
	get_tree().quit()


func _collect(node: Node, into: Array[MeshInstance3D]) -> void:
	if node is MeshInstance3D:
		into.append(node)
	for child: Node in node.get_children():
		_collect(child, into)


func _triangles(mesh: Mesh) -> int:
	var total := 0
	for s in mesh.get_surface_count():
		var arrays := mesh.surface_get_arrays(s)
		var idx = arrays[Mesh.ARRAY_INDEX]
		total += (idx.size() if idx != null else arrays[Mesh.ARRAY_VERTEX].size()) / 3
	return total
