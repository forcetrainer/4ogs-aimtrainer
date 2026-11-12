extends RefCounted
## The 4OGS look, shared by every screen: near-black surfaces, off-white
## condensed type, and the brand gradient (purple to cyan) kept for accents
## such as the logo, rules and the selected item, so it stays special.

const PURPLE := Color("a855f7")
const CYAN := Color("06b6d4")
const BG := Color(0.03, 0.035, 0.05)
const PANEL := Color(0.045, 0.05, 0.07, 0.92)
const TEXT := Color(0.93, 0.94, 0.96)
const DIM := Color(0.6, 0.63, 0.7)
const LINE := Color(1, 1, 1, 0.12)
const LOGO_PATH := "res://assets/brand/4ogs-logo.png"


static func font(weight := 500) -> SystemFont:
	var f := SystemFont.new()
	f.font_names = PackedStringArray(["Bahnschrift", "Segoe UI", "Arial"])
	f.font_weight = weight
	f.font_stretch = 85
	return f


## Slanted heavy type for titles, echoing the letterforms of the logo.
static func heading_font() -> FontVariation:
	var v := FontVariation.new()
	v.base_font = font(700)
	v.variation_transform = Transform2D(Vector2(1, 0.2), Vector2(0, 1), Vector2.ZERO)
	v.spacing_glyph = 2
	return v


## Fixed-width type for tables of results.
static func mono_font() -> SystemFont:
	var f := SystemFont.new()
	f.font_names = PackedStringArray(["Cascadia Mono", "Consolas", "Courier New"])
	return f


static func _box(bg: Color, left_border := Color.TRANSPARENT) -> StyleBoxFlat:
	var b := StyleBoxFlat.new()
	b.bg_color = bg
	b.content_margin_left = 22
	b.content_margin_right = 22
	b.content_margin_top = 9
	b.content_margin_bottom = 9
	if left_border.a > 0.0:
		b.border_width_left = 4
		b.border_color = left_border
	return b


static func theme() -> Theme:
	var t := Theme.new()
	t.default_font = font()
	t.default_font_size = 20
	t.set_color("font_color", "Label", TEXT)

	t.set_font("font", "Button", font(600))
	t.set_font_size("font_size", "Button", 28)
	t.set_color("font_color", "Button", DIM)
	t.set_color("font_hover_color", "Button", TEXT)
	t.set_color("font_focus_color", "Button", TEXT)
	t.set_color("font_pressed_color", "Button", TEXT)
	t.set_color("font_hover_pressed_color", "Button", TEXT)
	t.set_stylebox("normal", "Button", _box(Color.TRANSPARENT))
	t.set_stylebox("hover", "Button", _box(Color(1, 1, 1, 0.07), CYAN))
	t.set_stylebox("pressed", "Button", _box(Color(PURPLE, 0.28), PURPLE))
	t.set_stylebox("focus", "Button", _box(Color(1, 1, 1, 0.07), CYAN))
	t.set_stylebox("disabled", "Button", _box(Color.TRANSPARENT))

	var panel_box := StyleBoxFlat.new()
	panel_box.bg_color = PANEL
	panel_box.border_color = LINE
	panel_box.set_border_width_all(1)
	t.set_stylebox("panel", "PanelContainer", panel_box)

	var field := _box(Color(1, 1, 1, 0.06))
	field.content_margin_left = 10
	field.content_margin_right = 10
	field.content_margin_top = 5
	field.content_margin_bottom = 5
	var field_focus: StyleBoxFlat = field.duplicate()
	field_focus.border_color = CYAN
	field_focus.set_border_width_all(1)
	t.set_stylebox("normal", "LineEdit", field)
	t.set_stylebox("focus", "LineEdit", field_focus)
	t.set_color("font_color", "LineEdit", TEXT)
	t.set_font_size("font_size", "OptionButton", 20)
	t.set_font("font", "OptionButton", font())
	t.set_color("font_color", "OptionButton", TEXT)
	t.set_stylebox("normal", "OptionButton", field)
	t.set_stylebox("hover", "OptionButton", field_focus)
	t.set_stylebox("pressed", "OptionButton", field_focus)
	t.set_stylebox("focus", "OptionButton", field_focus)
	return t


## A bar filled with the brand gradient, left to right.
static func gradient_bar(width: float, height: float) -> TextureRect:
	var g := Gradient.new()
	g.set_color(0, PURPLE)
	g.set_color(1, CYAN)
	var tex := GradientTexture2D.new()
	tex.gradient = g
	tex.width = 256
	tex.height = 4
	var rect := TextureRect.new()
	rect.texture = tex
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_SCALE
	rect.custom_minimum_size = Vector2(width, height)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rect


static func label(text: String, size: int, color := TEXT, f: Font = null) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	if f:
		l.add_theme_font_override("font", f)
	return l


static func title(text: String, size := 44) -> Label:
	return label(text, size, TEXT, heading_font())


## The line that marks this as one of the team's side projects, not a team
## product: small, wide-spaced, in the brand cyan.
static func side_quest_tag() -> Label:
	var v := FontVariation.new()
	v.base_font = font(600)
	v.spacing_glyph = 5
	return label("A 4OGS SIDE QUEST", 16, CYAN, v)


## The logo at a given width, or an empty space if the image is missing.
static func logo(width: float) -> TextureRect:
	var rect := TextureRect.new()
	if ResourceLoader.exists(LOGO_PATH):
		rect.texture = load(LOGO_PATH)
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	rect.custom_minimum_size = Vector2(width, width * 957.0 / 2017.0)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rect


## A panel with the gradient rule along its top edge. Returns [panel, body];
## add content to body.
static func panel(width: float) -> Array:
	var p := PanelContainer.new()
	p.custom_minimum_size.x = width
	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 0)
	p.add_child(outer)
	outer.add_child(gradient_bar(width, 4))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 44)
	margin.add_theme_constant_override("margin_right", 44)
	margin.add_theme_constant_override("margin_top", 32)
	margin.add_theme_constant_override("margin_bottom", 34)
	outer.add_child(margin)
	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 14)
	margin.add_child(body)
	return [p, body]


## Small grey line of key prompts, as "KEY  ACTION" pairs.
static func hints(pairs: Array) -> Label:
	var parts := []
	for pair: Array in pairs:
		parts.append("%s  %s" % [pair[0], pair[1]])
	return label("        ".join(parts), 16, DIM)
