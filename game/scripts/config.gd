extends RefCounted
## Loads data files and the per-user settings shared by every scene.

const SETTINGS_PATH := "user://settings.json"
const DEFAULTS := {
	"dpi": 800.0,
	"sensitivity": 5.0,
	"fov": 110.0,
	"monitor_diagonal_in": 27.0,
	"view_distance_cm": 60.0,
}


static func load_json(path: String) -> Dictionary:
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed if parsed is Dictionary else {}


static func load_settings() -> Dictionary:
	var s := DEFAULTS.duplicate()
	if FileAccess.file_exists(SETTINGS_PATH):
		s.merge(load_json(SETTINGS_PATH), true)
	return s


static func save_settings(s: Dictionary) -> void:
	var f := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(s, "\t"))


static func median(values: Array) -> float:
	if values.is_empty():
		return NAN
	var sorted := values.duplicate()
	sorted.sort()
	var mid := sorted.size() / 2
	if sorted.size() % 2 == 1:
		return sorted[mid]
	return (sorted[mid - 1] + sorted[mid]) / 2.0
