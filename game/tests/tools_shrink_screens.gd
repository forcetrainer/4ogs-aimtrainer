extends SceneTree
## Offline tool: turns the full-size screenshots in docs/screens into
## smaller JPEGs for the README, and removes the originals.
## Run: godot --headless --path game --script res://tests/tools_shrink_screens.gd

const WIDTH := 1720


func _init() -> void:
	var dir := ProjectSettings.globalize_path("res://").path_join("../docs/screens").simplify_path()
	for f in DirAccess.get_files_at(dir):
		if not f.ends_with(".png"):
			continue
		var image := Image.load_from_file(dir.path_join(f))
		if image == null:
			continue
		var height := int(round(image.get_height() * float(WIDTH) / image.get_width()))
		image.resize(WIDTH, height, Image.INTERPOLATE_LANCZOS)
		image.convert(Image.FORMAT_RGB8)
		image.save_jpg(dir.path_join(f.get_basename() + ".jpg"), 0.88)
		DirAccess.remove_absolute(dir.path_join(f))
		print("SHRUNK %s" % f)
	# A banner for the top of the README: the title screen, cropped.
	var title := Image.load_from_file(dir.path_join("ui_splash.jpg"))
	if title:
		var band := int(title.get_height() * 0.62)
		title = title.get_region(Rect2i(0, int(title.get_height() * 0.18), title.get_width(), band))
		title.save_jpg(dir.path_join("banner.jpg"), 0.9)
	quit()
