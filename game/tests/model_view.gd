extends Node3D
## Development aid: renders a model from the side, top, back and front and
## saves the images. Run (not headless):
##   godot --path game res://tests/model_view.tscn -- --model=<res path> --out=<prefix>
##   optional: --textures=<res folder>/T_NAME  (applies _C, _N, _M, _R, _AO maps)

const Lighting = preload("res://scripts/lighting.gd")
const Viewmodel = preload("res://scripts/viewmodel.gd")


func _ready() -> void:
	var model_path := ""
	var out := ""
	var textures := ""
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--model="):
			model_path = arg.trim_prefix("--model=")
		elif arg.begins_with("--out="):
			out = arg.trim_prefix("--out=")
		elif arg.begins_with("--textures="):
			textures = arg.trim_prefix("--textures=")
	Lighting.build(self)
	var model: Node3D = load(model_path).instantiate()
	add_child(model)
	if textures != "":
		Viewmodel.apply_texture_set(model, textures)
	var box := Viewmodel.bounds(model)
	var center := box.get_center()
	var reach := box.get_longest_axis_size() * 0.75
	var camera := Camera3D.new()
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.size = box.get_longest_axis_size() * 1.15
	camera.near = 0.001
	add_child(camera)
	camera.make_current()
	var views := {
		"side_from_plus_x": [Vector3(reach, 0, 0), Vector3.UP],
		"top_from_plus_y": [Vector3(0, reach, 0), Vector3.FORWARD],
		"from_plus_z": [Vector3(0, 0, reach), Vector3.UP],
		"from_minus_z": [Vector3(0, 0, -reach), Vector3.UP],
	}
	for view_name: String in views:
		camera.look_at_from_position(center + views[view_name][0], center, views[view_name][1])
		await get_tree().create_timer(0.3).timeout
		get_viewport().get_texture().get_image().save_png("%s_%s.png" % [out, view_name])
	get_tree().quit()
