extends Node3D
## Development aid: lines up enemies in each stance a few metres away under
## the game's lighting and saves a picture. Left to right: standing still,
## strafing, crouching, lying, jumping, and one that has just been killed.
## Run: godot --path game res://tests/enemy_view.tscn -- --screenshot=<path>

const Lighting = preload("res://scripts/lighting.gd")
const Target = preload("res://scripts/target.gd")

var _targets: Array = []


func _ready() -> void:
	Lighting.build(self)
	var ground := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(100, 100)
	ground.mesh = plane
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.32, 0.33, 0.34)
	ground.material_override = mat
	add_child(ground)

	var line := [["stand", 0.0], ["stand", 3.4], ["crouch", 0.0], ["crouch", 2.0], ["prone", 0.0],
		["jump", 0.0], ["stand", 0.0]]
	for i in line.size():
		var t: Node3D = Target.new()
		add_child(t)
		t.setup(line[i][0], (i - 3.0) * 11.0, 7.0, 150.0, line[i][1])
		_targets.append(t)

	var camera := Camera3D.new()
	camera.position = Vector3(0, 1.7, 0)
	camera.fov = 50
	add_child(camera)
	camera.look_at(Vector3(0, 0.9, -7))
	camera.make_current()
	# Kill the last one so the fall can be seen part-way through.
	await get_tree().create_timer(0.6).timeout
	var last: Node3D = _targets.pop_back()
	last.die()
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--screenshot="):
			await get_tree().create_timer(1.0).timeout
			if "--hitboxes" in OS.get_cmdline_user_args():
				set_process(false)
				for t: Node3D in _targets:
					_draw_regions(t)
				await get_tree().process_frame
				await get_tree().process_frame
			get_viewport().get_texture().get_image().save_png(arg.trim_prefix("--screenshot="))
			get_tree().quit()


func _process(delta: float) -> void:
	for t: Node3D in _targets:
		t.update(delta)


## See-through shapes where each hit region is: red head, yellow torso,
## green arms, blue legs.
func _draw_regions(t: Node3D) -> void:
	var colours := {2: Color(1, 0.1, 0.1), 1: Color(1, 0.85, 0.1), 3: Color(0.1, 1, 0.3),
		4: Color(0.2, 0.5, 1)}
	for region: Dictionary in t.hit_regions():
		var a: Vector3 = region.a
		var b: Vector3 = region.b
		var mesh := MeshInstance3D.new()
		var capsule := CapsuleMesh.new()
		capsule.radius = region.radius
		capsule.height = (b - a).length() + region.radius * 2.0
		mesh.mesh = capsule
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(colours[region.kind], 0.45)
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mat.no_depth_test = true
		mesh.material_override = mat
		add_child(mesh)
		mesh.position = (a + b) / 2.0
		var axis := (b - a).normalized() if (b - a).length() > 1e-4 else Vector3.UP
		mesh.basis = Basis(Quaternion(Vector3.UP, axis))
