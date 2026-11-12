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


## Screen diagonal in inches from its physical width and height in cm.
static func diagonal_in_from_cm(width_cm: float, height_cm: float) -> float:
	return sqrt(width_cm * width_cm + height_cm * height_cm) / 2.54


## Diagonal from the lines "width,height" (cm) that the monitor query prints,
## one per connected screen. Returns -1 unless exactly one screen reports a
## plausible size: with several there is no telling which one the game is on.
static func parse_monitor_query(text: String) -> float:
	var sizes := []
	for line: String in text.split("\n", false):
		var parts := line.strip_edges().split(",")
		if parts.size() == 2 and float(parts[0]) >= 10.0 and float(parts[1]) >= 10.0:
			sizes.append(diagonal_in_from_cm(float(parts[0]), float(parts[1])))
	return sizes[0] if sizes.size() == 1 else -1.0


## The physical size the monitor itself reports to Windows, as a diagonal in
## inches, or -1 if it cannot be found. Monitors report whole centimetres,
## so this is good to about a quarter of an inch.
static func detect_monitor_diagonal_in() -> float:
	if OS.get_name() != "Windows":
		return -1.0
	var output := []
	var code := OS.execute("powershell", ["-NoProfile", "-Command",
		"Get-CimInstance -Namespace root/wmi -ClassName WmiMonitorBasicDisplayParams | " +
		"Where-Object Active | ForEach-Object { '{0},{1}' -f " +
		"$_.MaxHorizontalImageSize, $_.MaxVerticalImageSize }"], output)
	if code != 0 or output.is_empty():
		return -1.0
	return parse_monitor_query(output[0])
