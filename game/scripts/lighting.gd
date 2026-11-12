extends RefCounted
## Scene lighting from a photographed sky: the sky image lights and reflects
## on everything, and a shadow-casting sun is aimed at the brightest point
## in that image so shadows agree with the sky you can see.

const SKY_PATH := "res://assets/sky/kloofendal_48d_partly_cloudy_puresky_2k.hdr"


## Adds the environment and sun to parent. Returns the direction toward the sun.
static func build(parent: Node) -> Vector3:
	var env := Environment.new()
	var sun_dir := Vector3(0.35, 0.8, 0.45).normalized()
	var panorama: Texture2D = load(SKY_PATH) if ResourceLoader.exists(SKY_PATH) else null
	if panorama:
		var material := PanoramaSkyMaterial.new()
		material.panorama = panorama
		var sky := Sky.new()
		sky.sky_material = material
		env.background_mode = Environment.BG_SKY
		env.sky = sky
		env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
		env.reflected_light_source = Environment.REFLECTION_SOURCE_SKY
		# The sky image already contains the sun; keep its fill light modest
		# so the separate sun light provides the contrast and shadows.
		env.ambient_light_energy = 0.55
		var found := _brightest_direction(panorama.get_image())
		if found != Vector3.ZERO:
			sun_dir = found
	else:
		env.background_mode = Environment.BG_COLOR
		env.background_color = Color(0.36, 0.42, 0.48)
		env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
		env.ambient_light_color = Color(0.62, 0.62, 0.66)
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.ssao_enabled = true
	var world_env := WorldEnvironment.new()
	world_env.environment = env
	parent.add_child(world_env)

	var sun := DirectionalLight3D.new()
	sun.shadow_enabled = true
	sun.light_color = Color(1.0, 0.96, 0.9)
	sun.light_energy = 1.3
	sun.directional_shadow_max_distance = 120.0
	parent.add_child(sun)
	# A directional light shines along its -Z axis, away from the sun.
	var up := Vector3.FORWARD if absf(sun_dir.y) > 0.99 else Vector3.UP
	sun.look_at_from_position(Vector3.ZERO, -sun_dir, up)
	return sun_dir


## Direction of the brightest area of an equirectangular sky image.
static func _brightest_direction(image: Image) -> Vector3:
	if image == null or image.is_empty():
		return Vector3.ZERO
	if image.is_compressed() and image.decompress() != OK:
		return Vector3.ZERO
	var w := image.get_width()
	var h := image.get_height()
	var best := -1.0
	var best_uv := Vector2(0.5, 0.25)
	for y in range(0, h / 2, 4):
		for x in range(0, w, 4):
			var c := image.get_pixel(x, y)
			var lum := c.r + c.g + c.b
			if lum > best:
				best = lum
				best_uv = Vector2((x + 0.5) / w, (y + 0.5) / h)
	return direction_for_uv(best_uv)


## Godot's panorama mapping: u wraps around the horizon with u = 0.5 facing
## -Z, v runs from straight up (0) to straight down (1).
static func direction_for_uv(uv: Vector2) -> Vector3:
	var azimuth := (uv.x - 0.5) * TAU
	var elevation := PI / 2.0 - uv.y * PI
	return Vector3(sin(azimuth) * cos(elevation), sin(elevation), -cos(azimuth) * cos(elevation))
