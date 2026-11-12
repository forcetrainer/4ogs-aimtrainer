extends Control
## Settings screen. Every change is saved straight away.

const Style = preload("res://scripts/ui/style.gd")
const Config = preload("res://scripts/config.gd")
const Sens = preload("res://scripts/sens.gd")
const Placement = preload("res://scripts/placement.gd")

signal closed

var settings := {}

var _profile := {}
var _monitor: SpinBox
var _monitor_note: Label
var _derived: Label


func setup(s: Dictionary) -> void:
	settings = s


func _ready() -> void:
	_profile = Config.load_json("res://profiles/call_of_duty.json")
	set_anchors_preset(Control.PRESET_FULL_RECT)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 150)
	margin.add_theme_constant_override("margin_top", 110)
	margin.add_theme_constant_override("margin_bottom", 60)
	add_child(margin)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 14)
	margin.add_child(col)

	col.add_child(Style.title("SETTINGS", 52))
	var bar := Style.gradient_bar(380, 3)
	bar.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	col.add_child(bar)
	col.add_child(_spacer(18))

	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 28)
	grid.add_theme_constant_override("v_separation", 14)
	grid.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	col.add_child(grid)

	_row(grid, "SENSITIVITY", _spin("sensitivity", 0.01, 100.0, 0.01),
		"Use the same number as in Modern Warfare 4.")
	_row(grid, "MOUSE DPI", _spin("dpi", 100.0, 32000.0, 50.0), "")
	_row(grid, "FIELD OF VIEW", _spin("fov", 60.0, 120.0, 1.0),
		"Use the same number as in Modern Warfare 4.")

	var sight := OptionButton.new()
	sight.add_item("Red dot")
	sight.add_item("Iron sights")
	sight.selected = 0 if settings.get("optic", true) else 1
	sight.custom_minimum_size.x = 170
	sight.item_selected.connect(func(index: int):
		settings["optic"] = index == 0
		_changed())
	_row(grid, "SIGHT", sight, "Results are compared only with the same sight and field of view.")

	_monitor = _spin("monitor_diagonal_in", 13.0, 65.0, 0.1)
	_monitor.value_changed.connect(func(_v: float):
		settings["monitor_manual"] = true
		_changed())
	var monitor_box := HBoxContainer.new()
	monitor_box.add_theme_constant_override("separation", 10)
	monitor_box.add_child(_monitor)
	var detect := Button.new()
	detect.text = "DETECT"
	detect.add_theme_font_size_override("font_size", 18)
	detect.pressed.connect(func():
		if Config.refresh_monitor(settings, true):
			_monitor.set_value_no_signal(settings.monitor_diagonal_in)
		_changed())
	monitor_box.add_child(detect)
	_monitor_note = Style.label("", 17, Style.DIM)
	grid.add_child(Style.label("MONITOR SIZE (IN)", 20, Style.DIM))
	grid.add_child(monitor_box)
	grid.add_child(_monitor_note)

	_row(grid, "VIEWING DISTANCE (CM)", _spin("view_distance_cm", 30.0, 150.0, 1.0),
		"Eye to screen. A rough measurement is enough.")

	col.add_child(_spacer(10))
	_derived = Style.label("", 18, Style.DIM)
	col.add_child(_derived)
	col.add_child(_spacer(18))

	var back := Button.new()
	back.text = "BACK"
	back.alignment = HORIZONTAL_ALIGNMENT_LEFT
	back.custom_minimum_size.x = 440
	back.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	back.pressed.connect(func(): closed.emit())
	col.add_child(back)
	back.grab_focus()
	_refresh()


func _spacer(height: float) -> Control:
	var c := Control.new()
	c.custom_minimum_size.y = height
	return c


func _row(grid: GridContainer, text: String, control: Control, note: String) -> void:
	grid.add_child(Style.label(text, 20, Style.DIM))
	grid.add_child(control)
	grid.add_child(Style.label(note, 17, Style.DIM))


func _spin(key: String, low: float, high: float, step: float) -> SpinBox:
	var s := SpinBox.new()
	s.min_value = low
	s.max_value = high
	s.step = step
	s.value = settings[key]
	s.custom_minimum_size.x = 170
	s.value_changed.connect(func(v: float):
		settings[key] = v
		_changed())
	return s


func _changed() -> void:
	Config.save_settings(settings)
	_refresh()


func _refresh() -> void:
	if settings.get("monitor_manual", false):
		_monitor_note.text = "Set by hand. DETECT reads the size from the monitor."
	elif settings.get("monitor_detected_for", "") != "":
		_monitor_note.text = "Read from the monitor."
	else:
		_monitor_note.text = "Not detected; this is a default."
	var reach := Placement.screen_visual_half_deg(settings.monitor_diagonal_in,
		settings.view_distance_cm, get_viewport().get_visible_rect().size.aspect())
	_derived.text = "%.1f cm of mouse travel for a full turn.    The screen covers %d degrees of your vision to each side, %d up and down." % [
		Sens.cm_per_360(settings.dpi, _profile.yaw_constant, settings.sensitivity),
		reach.x, reach.y]
