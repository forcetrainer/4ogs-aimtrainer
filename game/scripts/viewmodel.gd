extends RefCounted
## Helpers for first-person weapon models.


## Build a first-person weapon from a weapon file's "model" block.
## Returns: root (attach to the camera and position it), optic (may be null),
## flash, and the root positions for hip fire and for aiming with each sight.
static func build(weapon: Dictionary) -> Dictionary:
	var model: Dictionary = weapon.model
	var root := Node3D.new()
	# The models face +Z; the camera looks along -Z.
	var pivot := Node3D.new()
	pivot.rotation_degrees.y = 180.0
	root.add_child(pivot)

	var gun: Node3D = load(model.scene).instantiate()
	pivot.add_child(gun)
	if model.has("textures"):
		apply_texture_set(gun, model.textures)

	var optic: Node3D = null
	var optic_eye := _vec(model.irons_eye)
	if model.has("optic"):
		var o: Dictionary = model.optic
		optic = load(o.scene).instantiate()
		optic.scale = Vector3.ONE * o.scale
		optic.position = _vec(o.position)
		pivot.add_child(optic)
		# The aiming dot is drawn by the HUD so it always marks the true aim point.
		for mesh_name: String in o.get("hide_meshes", []):
			var hidden := optic.find_child(mesh_name, true, false)
			if hidden:
				hidden.visible = false
		var glass := optic.find_child(o.get("glass_mesh", ""), true, false) as MeshInstance3D
		if glass:
			var clear: BaseMaterial3D = glass.get_active_material(0).duplicate()
			clear.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			clear.albedo_color = Color(1, 1, 1, 0.1)
			glass.set_surface_override_material(0, clear)
		optic_eye = Vector3(o.position[0], o.position[1] + o.dot_height * o.scale,
			o.position[2] + o.glass_z * o.scale - o.eye_relief)

	var flash := MeshInstance3D.new()
	var flash_mesh := SphereMesh.new()
	flash_mesh.radius = 0.04
	flash_mesh.height = 0.08
	flash.mesh = flash_mesh
	var flash_mat := StandardMaterial3D.new()
	flash_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	flash_mat.albedo_color = Color(1.0, 0.85, 0.45)
	flash.material_override = flash_mat
	flash.position = _vec(model.muzzle)
	flash.visible = false
	pivot.add_child(flash)

	for entry: Array in _meshes(root, Transform3D.IDENTITY):
		(entry[0] as MeshInstance3D).cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	return {
		"root": root, "optic": optic, "flash": flash,
		"hip": _vec(model.hip_position),
		"hip_rotation": _vec(model.get("hip_rotation_deg", [0.0, 0.0, 0.0])),
		"fov_vertical": float(model.get("viewmodel_fov_vertical_deg", 50.0)),
		"irons": _root_position(_vec(model.irons_eye)),
		"optic_ads": _root_position(optic_eye),
		"irons_pitch": float(model.get("irons_pitch_deg", 0.0)),
		"gun_mesh": _meshes(gun, Transform3D.IDENTITY)[0][0],
		"mount_surface": int(model.get("optic_mount_surface", -1)),
	}


## Show or hide the part of the gun that carries the optic (a rail that
## would otherwise block the iron sights).
static func set_mount_visible(gun_mesh: MeshInstance3D, surface: int, visible: bool) -> void:
	if surface < 0:
		return
	var current := gun_mesh.get_surface_override_material(surface)
	if visible:
		if current and current.has_meta("shown"):
			gun_mesh.set_surface_override_material(surface, current.get_meta("shown"))
	elif current == null or not current.has_meta("shown"):
		var hidden := StandardMaterial3D.new()
		hidden.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		hidden.albedo_color = Color(0, 0, 0, 0)
		hidden.set_meta("shown", current)
		gun_mesh.set_surface_override_material(surface, hidden)


static func _vec(values: Array) -> Vector3:
	return Vector3(values[0], values[1], values[2])


## Where the weapon root must sit so the camera ends up at a given eye point
## in the model's space (after the half turn that faces the muzzle forward).
static func _root_position(eye: Vector3) -> Vector3:
	return Vector3(eye.x, -eye.y, eye.z)


## Combined bounds of every mesh under a node, in that node's parent space.
static func bounds(root: Node3D) -> AABB:
	var result := AABB()
	var first := true
	for entry: Array in _meshes(root, root.transform):
		var box: AABB = entry[1] * entry[0].mesh.get_aabb()
		result = box if first else result.merge(box)
		first = false
	return result


static func _meshes(node: Node, xf: Transform3D) -> Array:
	var found := []
	if node is MeshInstance3D and node.mesh:
		found.append([node, xf])
	for child in node.get_children():
		var child_xf: Transform3D = xf
		if child is Node3D:
			child_xf = xf * (child as Node3D).transform
		found.append_array(_meshes(child, child_xf))
	return found


## Give every surface of a model one PBR material built from a texture set
## named <prefix>_C (colour), _N (normal), _M (metallic), _R (roughness)
## and _AO (ambient occlusion). Missing maps are skipped.
static func apply_texture_set(root: Node3D, prefix: String) -> void:
	var mat := StandardMaterial3D.new()
	var colour := _texture(prefix + "_C.png")
	if colour:
		mat.albedo_texture = colour
	var normal := _texture(prefix + "_N.png")
	if normal:
		mat.normal_enabled = true
		mat.normal_texture = normal
	var metallic := _texture(prefix + "_M.png")
	if metallic:
		mat.metallic = 1.0
		mat.metallic_texture = metallic
	var roughness := _texture(prefix + "_R.png")
	if roughness:
		mat.roughness = 1.0
		mat.roughness_texture = roughness
	var ao := _texture(prefix + "_AO.png")
	if ao:
		mat.ao_enabled = true
		mat.ao_texture = ao
	for entry: Array in _meshes(root, Transform3D.IDENTITY):
		var mesh_instance: MeshInstance3D = entry[0]
		for i in mesh_instance.mesh.get_surface_count():
			mesh_instance.set_surface_override_material(i, mat)


static func _texture(path: String) -> Texture2D:
	return load(path) if ResourceLoader.exists(path) else null
