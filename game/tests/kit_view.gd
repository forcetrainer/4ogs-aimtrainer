extends Node3D
## Development aid: shows the kit building under the game's lighting with a
## person-sized capsule beside it, and saves a picture.
## Run: godot --path game res://tests/kit_view.tscn -- --screenshot=<path> [--side]

const Lighting = preload("res://scripts/lighting.gd")
const Kit = preload("res://scripts/kit.gd")


func _ready() -> void:
	Lighting.build(self)
	var ground := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(200, 200)
	ground.mesh = plane
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.3, 0.31, 0.32)
	ground.material_override = mat
	add_child(ground)

	var building := Kit.building()
	add_child(building)
	var box := Kit.bounds(building)
	print("KITVIEW size %.1f x %.1f x %.1f, lowest point %.2f" % [
		box.size.x, box.size.y, box.size.z, box.position.y])

	# A standing person, 1.8 m, in front of it.
	var person := MeshInstance3D.new()
	var capsule := CapsuleMesh.new()
	capsule.radius = 0.25
	capsule.height = 1.8
	person.mesh = capsule
	var red := StandardMaterial3D.new()
	red.albedo_color = Color(0.9, 0.2, 0.15)
	person.material_override = red
	person.position = Vector3(box.get_center().x, 0.9, box.end.z + 1.5)
	add_child(person)

	var camera := Camera3D.new()
	var args := OS.get_cmdline_user_args()
	var centre := Vector3(box.get_center().x, box.size.y * 0.35, box.get_center().z)
	var reach := maxf(box.size.x, box.size.z)
	if "--side" in args:
		camera.position = centre + Vector3(reach * 1.1, box.size.y * 0.1, reach * 0.9)
	else:
		camera.position = Vector3(centre.x + reach * 0.25, 1.7, box.end.z + reach * 1.1)
	add_child(camera)
	camera.look_at(centre)
	camera.fov = 60
	camera.make_current()
	for arg: String in args:
		if arg.begins_with("--screenshot="):
			await get_tree().create_timer(1.5).timeout
			get_viewport().get_texture().get_image().save_png(arg.trim_prefix("--screenshot="))
			get_tree().quit()
