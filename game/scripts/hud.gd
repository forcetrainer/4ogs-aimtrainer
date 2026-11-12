extends CanvasLayer
## Everything drawn over the 3D view. While a run is being played that is
## only what a game would show: the crosshair, the hit marker, the damage
## flash and the edge bars that stand in for a directional sound cue. No
## numbers appear until the run is over. Briefing, results and pause are
## panels shown between runs.

const Style = preload("res://scripts/ui/style.gd")

signal resume_pressed
signal quit_pressed

const MARKER_USEC := 80_000
const DAMAGE_USEC := 250_000
const CUE_USEC := 350_000

var hit_marker: Label
var crosshair: ColorRect
var cue_left: ColorRect
var cue_right: ColorRect
var damage_overlay: ColorRect

var _root: Control
var _shade: ColorRect
var _holder: CenterContainer
var _panel: Control
var _marker_until_usec := 0
var _damage_until_usec := 0
var _cue_until_usec := 0


func _ready() -> void:
	_root = Control.new()
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.theme = Style.theme()
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_root)

	damage_overlay = ColorRect.new()
	damage_overlay.color = Color(0.8, 0.05, 0.05, 0.35)
	damage_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	damage_overlay.visible = false
	_root.add_child(damage_overlay)

	cue_left = ColorRect.new()
	cue_right = ColorRect.new()
	for bar: ColorRect in [cue_left, cue_right]:
		bar.color = Color(1.0, 0.25, 0.2, 0.6)
		bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bar.visible = false
		_root.add_child(bar)

	crosshair = ColorRect.new()
	crosshair.color = Color(1.0, 0.2, 0.15)
	crosshair.size = Vector2(3, 3)
	crosshair.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(crosshair)

	hit_marker = Label.new()
	hit_marker.text = "x"
	hit_marker.add_theme_font_size_override("font_size", 26)
	hit_marker.visible = false
	_root.add_child(hit_marker)

	_shade = ColorRect.new()
	_shade.color = Color(0, 0, 0, 0.62)
	_shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	_shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_shade.visible = false
	_root.add_child(_shade)

	_holder = CenterContainer.new()
	_holder.set_anchors_preset(Control.PRESET_FULL_RECT)
	_holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_holder)

	get_viewport().size_changed.connect(_layout)
	_layout()


func _layout() -> void:
	var size := get_viewport().get_visible_rect().size
	damage_overlay.position = Vector2.ZERO
	damage_overlay.size = size
	cue_left.position = Vector2(0, size.y * 0.25)
	cue_left.size = Vector2(22, size.y * 0.5)
	cue_right.position = Vector2(size.x - 22, size.y * 0.25)
	cue_right.size = Vector2(22, size.y * 0.5)
	crosshair.position = size / 2.0 - crosshair.size / 2.0
	hit_marker.position = size / 2.0 + Vector2(12, -30)


# ---------- panels between runs ----------

func _show_panel(panel: Control, shade: bool) -> void:
	hide_panel()
	_panel = panel
	_holder.add_child(panel)
	_shade.visible = shade


func hide_panel() -> void:
	if _panel:
		_panel.queue_free()
		_panel = null
	_shade.visible = false


func panel_open() -> bool:
	return _panel != null


## What is about to happen, shown before a run starts.
func show_briefing(heading: String, lines: Array, hint_pairs: Array) -> void:
	var made := Style.panel(760)
	var body: VBoxContainer = made[1]
	body.add_child(Style.title(heading.to_upper()))
	for line: String in lines:
		var l := Style.label(line, 20, Style.DIM)
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.custom_minimum_size.x = 660
		body.add_child(l)
	body.add_child(_spacer(8))
	body.add_child(Style.hints(hint_pairs))
	_show_panel(made[0], true)


## Results. The first line of `text` becomes the heading; the rest is a
## table in fixed-width type.
func show_summary(text: String, hint_pairs: Array) -> void:
	var made := Style.panel(900)
	var body: VBoxContainer = made[1]
	var lines := text.split("\n")
	body.add_child(Style.title(lines[0].to_upper(), 36))
	var rest := "\n".join(lines.slice(1)).strip_edges()
	body.add_child(Style.label(rest, 17, Style.TEXT, Style.mono_font()))
	body.add_child(_spacer(6))
	body.add_child(Style.hints(hint_pairs))
	_show_panel(made[0], true)


func show_pause(note: String) -> void:
	var made := Style.panel(520)
	var body: VBoxContainer = made[1]
	body.add_child(Style.title("PAUSED"))
	body.add_child(Style.label(note, 18, Style.DIM))
	body.add_child(_spacer(4))
	var resume := _button("RESUME")
	resume.pressed.connect(func(): resume_pressed.emit())
	body.add_child(resume)
	var quit := _button("QUIT TO MENU")
	quit.pressed.connect(func(): quit_pressed.emit())
	body.add_child(quit)
	_show_panel(made[0], true)
	resume.grab_focus()


func _button(text: String) -> Button:
	var b := Button.new()
	b.text = text
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	return b


func _spacer(height: float) -> Control:
	var c := Control.new()
	c.custom_minimum_size.y = height
	return c


# ---------- during play ----------

func hit(now_usec: int) -> void:
	_marker_until_usec = now_usec + MARKER_USEC


func damage(now_usec: int) -> void:
	_damage_until_usec = now_usec + DAMAGE_USEC


## Flash the edge bar on the side a target appeared (negative = left).
func cue(offset_deg: float, now_usec: int) -> void:
	cue_left.visible = offset_deg < 0.0
	cue_right.visible = offset_deg > 0.0
	_cue_until_usec = now_usec + CUE_USEC


func update(now_usec: int, crosshair_visible: bool) -> void:
	crosshair.visible = crosshair_visible and _panel == null
	hit_marker.visible = now_usec < _marker_until_usec
	damage_overlay.visible = now_usec < _damage_until_usec
	if now_usec >= _cue_until_usec:
		cue_left.visible = false
		cue_right.visible = false
