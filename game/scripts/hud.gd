extends CanvasLayer
## Everything drawn over the 3D view: crosshair, hit marker, status text,
## fight result, run summary, the damage flash, and the edge bars that stand
## in for a directional sound cue.

const MARKER_USEC := 80_000
const DAMAGE_USEC := 250_000
const CUE_USEC := 350_000

var status_label: Label
var result_label: Label
var summary_label: Label
var hit_marker: Label
var crosshair: ColorRect
var cue_left: ColorRect
var cue_right: ColorRect
var damage_overlay: ColorRect

var _marker_until_usec := 0
var _damage_until_usec := 0
var _cue_until_usec := 0


func _ready() -> void:
	damage_overlay = ColorRect.new()
	damage_overlay.color = Color(0.8, 0.05, 0.05, 0.35)
	damage_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	damage_overlay.visible = false
	add_child(damage_overlay)

	cue_left = ColorRect.new()
	cue_right = ColorRect.new()
	for bar: ColorRect in [cue_left, cue_right]:
		bar.color = Color(1.0, 0.25, 0.2, 0.6)
		bar.visible = false
		add_child(bar)

	crosshair = ColorRect.new()
	crosshair.color = Color(1.0, 0.2, 0.15)
	crosshair.size = Vector2(4, 4)
	add_child(crosshair)

	hit_marker = Label.new()
	hit_marker.text = "x"
	hit_marker.add_theme_font_size_override("font_size", 30)
	hit_marker.visible = false
	add_child(hit_marker)

	status_label = Label.new()
	status_label.position = Vector2(24, 20)
	status_label.add_theme_font_size_override("font_size", 18)
	add_child(status_label)

	result_label = Label.new()
	result_label.add_theme_font_size_override("font_size", 22)
	result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(result_label)

	summary_label = Label.new()
	summary_label.add_theme_font_size_override("font_size", 24)
	summary_label.visible = false
	add_child(summary_label)

	get_viewport().size_changed.connect(_layout)
	_layout()


func _layout() -> void:
	var size := get_viewport().get_visible_rect().size
	damage_overlay.position = Vector2.ZERO
	damage_overlay.size = size
	cue_left.position = Vector2(0, size.y * 0.25)
	cue_left.size = Vector2(28, size.y * 0.5)
	cue_right.position = Vector2(size.x - 28, size.y * 0.25)
	cue_right.size = Vector2(28, size.y * 0.5)
	crosshair.position = size / 2.0 - crosshair.size / 2.0
	hit_marker.position = size / 2.0 + Vector2(14, -34)
	result_label.position = Vector2(0, size.y * 0.8)
	result_label.size = Vector2(size.x, 40)
	summary_label.position = Vector2(size.x * 0.28, size.y * 0.14)


func set_status(text: String) -> void:
	status_label.text = text


func set_result(text: String) -> void:
	result_label.text = text


func show_summary(text: String) -> void:
	summary_label.text = text
	summary_label.visible = true
	result_label.text = ""


func hide_summary() -> void:
	summary_label.visible = false


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
	crosshair.visible = crosshair_visible
	hit_marker.visible = now_usec < _marker_until_usec
	damage_overlay.visible = now_usec < _damage_until_usec
	if now_usec >= _cue_until_usec:
		cue_left.visible = false
		cue_right.visible = false
