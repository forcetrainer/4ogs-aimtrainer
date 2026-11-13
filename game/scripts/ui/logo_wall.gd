extends Control
## The wall of logos every game shows on the way in: engines, studios,
## middleware. Every company here is made up, and each one is a 4OGS in-joke
## (the facts are from 4ogs.racing). Nothing imitates a real company's
## name or mark. The logos are drawn here, in white on black as these
## slides always are, each with its own typeface, layout and mark so no two
## look alike.

const INK := Color(0.93, 0.94, 0.96)
const FAINT := Color(0.93, 0.94, 0.96, 0.55)
const TILE := Vector2(350, 190)

## name: the wordmark. sub: the line under or beside it. fonts: typefaces to
## try, in order. weight, slant (0 = upright), spacing (extra pixels between
## letters), size. layout: "left" (mark beside the name), "top" (mark
## above), "plain" (name alone over a rule), "framed" (name in a box),
## "badge" (mark with the name set small beneath). mark: which drawing.
const LOGOS := [
	{"name": "LOAD-BEARING", "sub": "ENGINE  ·  purpose unknown", "fonts": ["Arial Black", "Arial"],
		"weight": 900, "slant": 0.0, "spacing": 1, "size": 30, "layout": "left", "mark": "bulb"},
	{"name": "thrown rod", "sub": "i n t e r a c t i v e", "fonts": ["Georgia", "Times New Roman"],
		"weight": 400, "slant": 0.22, "spacing": 0, "size": 40, "layout": "top", "mark": "rod"},
	{"name": "PROBE/95", "sub": "PHYSICS  ·  120ish MPH", "fonts": ["Impact", "Arial Black"],
		"weight": 400, "slant": 0.28, "spacing": 2, "size": 46, "layout": "plain", "mark": ""},
	{"name": "Redneckineering", "sub": "Plan B Middleware", "fonts": ["Courier New", "Consolas"],
		"weight": 700, "slant": 0.0, "spacing": 0, "size": 27, "layout": "left", "mark": "tape"},
	{"name": "SERPENTINE", "sub": "belt software  ·  snapped once", "fonts": ["Century Gothic", "Segoe UI"],
		"weight": 300, "slant": 0.0, "spacing": 9, "size": 26, "layout": "top", "mark": "belt"},
	{"name": "KILLSWITCH", "sub": "frequently mistaken for STARTER", "fonts": ["Consolas", "Lucida Console"],
		"weight": 700, "slant": 0.0, "spacing": 3, "size": 32, "layout": "framed", "mark": ""},
	{"name": "Things 1–5", "sub": "A  BRIAN'S  MOM  PRODUCTION", "fonts": ["Palatino Linotype", "Georgia"],
		"weight": 700, "slant": 0.0, "spacing": 0, "size": 36, "layout": "left", "mark": "five"},
	{"name": "PAMMY", "sub": "COOKIE NETWORKING  ·  0 usable frequencies",
		"fonts": ["Trebuchet MS", "Verdana"], "weight": 700, "slant": 0.0, "spacing": 12, "size": 34,
		"layout": "badge", "mark": "cookie"},
	{"name": "PRINTED TWICE", "sub": "3D  ·  we forgot about height", "fonts": ["Bahnschrift", "Arial"],
		"weight": 700, "slant": 0.0, "spacing": 4, "size": 28, "layout": "left", "mark": "layers"},
	{"name": "Thoughts & Prayers", "sub": "C  A  P  I  T  A  L", "fonts": ["Times New Roman", "Georgia"],
		"weight": 400, "slant": 0.0, "spacing": 0, "size": 34, "layout": "plain", "mark": ""},
	{"name": "JEFFCAL", "sub": "scheduling  ·  47 conflicts", "fonts": ["Verdana", "Tahoma"],
		"weight": 700, "slant": 0.0, "spacing": 2, "size": 32, "layout": "left", "mark": "calendar"},
	{"name": "0.1% STUDIOS", "sub": "#1 ON THE SIM", "fonts": ["Franklin Gothic Medium", "Arial"],
		"weight": 700, "slant": 0.15, "spacing": 1, "size": 34, "layout": "top", "mark": "podium"},
	{"name": "BRONZE CAGE", "sub": "SAFETY CERTIFIED  ·  DON'T WANT TO TEST", "fonts": ["Cambria", "Georgia"],
		"weight": 700, "slant": 0.0, "spacing": 6, "size": 26, "layout": "badge", "mark": "cage"},
	{"name": "accidental\ndischarge", "sub": "PARTICLE FX  ·  80% of the time", "fonts": ["Segoe UI", "Arial"],
		"weight": 200, "slant": 0.0, "spacing": 1, "size": 34, "layout": "left", "mark": "spray"},
	{"name": "D N F", "sub": "ENGINE  ·  99.9% breakdown. Called it.",
		"fonts": ["Arial Black", "Impact"], "weight": 900, "slant": 0.0, "spacing": 10, "size": 44,
		"layout": "left", "mark": "flag"},
]
const SMALL_PRINT := "All trademarks are the property of people who should have thought about that.   " \
	+ "No cars were harmed in the making of this game... yet.   TO BE CONTINUED."

## The second helping, shown after "you thought we were done".
const MORE_LOGOS := [
	{"name": "FUELSOCK", "sub": "AUDIO  ·  starved once at Sonoma", "fonts": ["Tahoma", "Verdana"],
		"weight": 700, "slant": 0.0, "spacing": 5, "size": 30, "layout": "left", "mark": "sock"},
	{"name": "55/140", "sub": "G A M E S  ·  a team record", "fonts": ["Impact", "Arial Black"],
		"weight": 400, "slant": 0.0, "spacing": 3, "size": 52, "layout": "plain", "mark": ""},
	{"name": "to be continued…", "sub": "S T U D I O S", "fonts": ["Georgia", "Times New Roman"],
		"weight": 400, "slant": 0.25, "spacing": 0, "size": 34, "layout": "plain", "mark": ""},
	{"name": "GRAVITY '86", "sub": "RAGDOLL  ·  I didn't push him", "fonts": ["Franklin Gothic Medium", "Arial"],
		"weight": 700, "slant": 0.0, "spacing": 2, "size": 30, "layout": "left", "mark": "fall"},
	{"name": "FOURTH RUN", "sub": "parts logistics  ·  same store, same day", "fonts": ["Century Gothic", "Segoe UI"],
		"weight": 700, "slant": 0.2, "spacing": 4, "size": 28, "layout": "top", "mark": "road"},
	{"name": "DUCT TAPE DIAMOND", "sub": "R E N D E R I N G", "fonts": ["Cambria", "Georgia"],
		"weight": 700, "slant": 0.0, "spacing": 4, "size": 22, "layout": "badge", "mark": "diamond"},
	{"name": "Rattle Can Gold", "sub": "SHADERS  ·  one coat, outdoors", "fonts": ["Trebuchet MS", "Verdana"],
		"weight": 700, "slant": 0.0, "spacing": 0, "size": 30, "layout": "left", "mark": "can"},
	{"name": "prayers & pizza", "sub": "N E T C O D E", "fonts": ["Courier New", "Consolas"],
		"weight": 700, "slant": 0.0, "spacing": 0, "size": 28, "layout": "top", "mark": "pizza"},
	{"name": "HEEL-TOE", "sub": "input  ·  can't, may kill us", "fonts": ["Arial Black", "Arial"],
		"weight": 900, "slant": 0.0, "spacing": 6, "size": 30, "layout": "framed", "mark": ""},
	{"name": "THE BEAST", "sub": "RUNTIME v0.95  ·  prefers to travel by trailer",
		"fonts": ["Bahnschrift", "Arial"], "weight": 700, "slant": 0.18, "spacing": 3, "size": 34,
		"layout": "left", "mark": "trailer"},
]
const PAGES := [LOGOS, MORE_LOGOS]
## The key each page claims will skip it. None of them do.
const CLAIMED_KEYS := [[KEY_SPACE, KEY_ESCAPE], [KEY_P]]
const CLAIMED_TEXT := ["SPACE  or  ESC    SKIP", "P    SKIP"]
## The key that really does skip, which the screen never mentions.
const REAL_SKIP_KEY := KEY_4
const PAGE_SECONDS := 9.0
## Each failed attempt to skip makes the page last this much longer.
const PENALTY_SECONDS := 2.5
const GOTCHA_SECONDS := 2.2
const ROASTS := [
	"Skipping? Bold, from someone who needs an aim trainer.",
	"That key is frequently mistaken for the skip button. It is the kill switch.",
	"Phil should have thought about that before pressing it.",
	"The skip button is load-bearing. Purpose unknown.",
	"Skip failed tech inspection.",
	"Sleep is for teams with time. So is skipping.",
	"0.1% chance of that working.",
	"We paid one dollar of pure belief for these logos. Look at them.",
	"Skip suffered a suspected thrown rod. Teardown pending.",
	"Jeff will get to your skip request. Attendance probability: TBD.",
	"Every press adds time. We printed that rule twice.",
]
const WRONG_KEY_ROASTS := [
	"Wrong key. It moved. Keep up.",
	"That was the old key. Very racy. Questionably pacey.",
]
const CLICK_ROAST := "Clicking? This is not the title screen."

## Emitted when the wall has finally finished (or the real key was found).
signal finished

## Which page to open on (for taking pictures of the second one).
var start_page := 0

var _page := 0
var _left := PAGE_SECONDS
var _gotcha_left := 0.0
var _roasts_used := 0
var _center: CenterContainer
var _grid: GridContainer
var _prompt: Label
var _roast: Label
var _gotcha: Label
var _legal: Label


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var bg := ColorRect.new()
	bg.color = Color(0.02, 0.022, 0.03)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	_center = CenterContainer.new()
	_center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_center)
	_legal = _text(SMALL_PRINT, ["Segoe UI", "Arial"], 400, 0.0, 1, 13, FAINT)
	_legal.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_legal.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	_legal.offset_top = -64
	_legal.offset_bottom = -40
	add_child(_legal)
	_roast = _text("", ["Segoe UI", "Arial"], 600, 0.0, 0, 24)
	_roast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_roast.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	_roast.offset_top = -128
	_roast.offset_bottom = -92
	_roast.modulate.a = 0.0
	add_child(_roast)
	_gotcha = _text("YOU THOUGHT WE WERE DONE.", ["Arial Black", "Impact"], 900, 0.0, 6, 64)
	_gotcha.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_gotcha.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_gotcha.set_anchors_preset(Control.PRESET_FULL_RECT)
	_gotcha.visible = false
	add_child(_gotcha)
	_prompt = _text("", ["Segoe UI", "Arial"], 600, 0.0, 2, 15, FAINT)
	add_child(_prompt)
	_show_page(start_page)


func _show_page(page: int) -> void:
	_page = page
	_left = PAGE_SECONDS
	_gotcha.visible = false
	_legal.visible = true
	if _grid:
		_grid.queue_free()
	_grid = GridContainer.new()
	_grid.columns = 5
	_grid.add_theme_constant_override("h_separation", 6)
	_grid.add_theme_constant_override("v_separation", 34)
	_center.add_child(_grid)
	for spec: Dictionary in PAGES[page]:
		_grid.add_child(_tile(spec))
	# The offer to skip moves each time: bottom right, then top left.
	_prompt.text = CLAIMED_TEXT[page]
	_prompt.visible = true
	if page == 0:
		_prompt.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
		_prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_prompt.offset_left = -420
		_prompt.offset_right = -70
		_prompt.offset_top = -118
		_prompt.offset_bottom = -92
	else:
		_prompt.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		_prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		_prompt.offset_left = 70
		_prompt.offset_right = 420
		_prompt.offset_top = 54
		_prompt.offset_bottom = 80


func _process(delta: float) -> void:
	if _gotcha_left > 0.0:
		_gotcha_left -= delta
		if _gotcha_left <= 0.0:
			_show_page(_page + 1)
		return
	_left -= delta
	if _left > 0.0:
		return
	if _page + 1 < PAGES.size():
		# Looks finished. Is not.
		_grid.visible = false
		_prompt.visible = false
		_legal.visible = false
		_roast.modulate.a = 0.0
		_gotcha.visible = true
		_gotcha_left = GOTCHA_SECONDS
	else:
		set_process(false)
		finished.emit()


func _say(line: String) -> void:
	_roast.text = line
	_roast.modulate.a = 1.0
	var fade := create_tween()
	fade.tween_interval(2.6)
	fade.tween_property(_roast, "modulate:a", 0.0, 0.5)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_viewport().set_input_as_handled()
		if _gotcha_left <= 0.0:
			_say(CLICK_ROAST)
		return
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	get_viewport().set_input_as_handled()
	if event.keycode == REAL_SKIP_KEY:
		set_process(false)
		finished.emit()
		return
	if _gotcha_left > 0.0:
		return
	if event.keycode in CLAIMED_KEYS[_page]:
		# It asked for this key. It lied, and it costs time.
		_say(ROASTS[_roasts_used % ROASTS.size()])
		_roasts_used += 1
		_left = minf(_left + PENALTY_SECONDS, PAGE_SECONDS * 2.0)
	elif _page > 0 and event.keycode in CLAIMED_KEYS[_page - 1]:
		_say(WRONG_KEY_ROASTS[_roasts_used % WRONG_KEY_ROASTS.size()])
		_roasts_used += 1


func _text(text: String, fonts: Array, weight: int, slant: float, spacing: int, size: int,
		colour := INK) -> Label:
	var base := SystemFont.new()
	base.font_names = PackedStringArray(fonts)
	base.font_weight = weight
	var face := FontVariation.new()
	face.base_font = base
	face.spacing_glyph = spacing
	if slant != 0.0:
		face.variation_transform = Transform2D(Vector2(1, slant), Vector2(0, 1), Vector2.ZERO)
	var label := Label.new()
	label.text = text
	label.add_theme_font_override("font", face)
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", colour)
	label.add_theme_constant_override("line_spacing", -8)
	return label


func _tile(spec: Dictionary) -> Control:
	var tile := CenterContainer.new()
	tile.custom_minimum_size = TILE
	var name_label := _text(spec.name, spec.fonts, spec.weight, spec.slant, spec.spacing, spec.size)
	var sub := _text(spec.sub, ["Segoe UI", "Arial"], 600, 0.0, 2, 11, FAINT)
	var words := VBoxContainer.new()
	words.add_theme_constant_override("separation", 5)
	if spec.mark != "":
		words.add_child(name_label)
		words.add_child(sub)
	var mark: Control = null
	if spec.mark != "":
		mark = Mark.new()
		mark.kind = spec.mark
		mark.custom_minimum_size = Vector2(72, 72)
	match spec.layout:
		"left":
			var row := HBoxContainer.new()
			row.add_theme_constant_override("separation", 14)
			mark.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			words.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			row.add_child(mark)
			row.add_child(words)
			tile.add_child(row)
		"top", "badge":
			var column := VBoxContainer.new()
			column.add_theme_constant_override("separation", 8 if spec.layout == "top" else 12)
			mark.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			if spec.layout == "badge":
				mark.custom_minimum_size = Vector2(92, 92)
			name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			column.add_child(mark)
			column.add_child(words)
			tile.add_child(column)
		"framed":
			var frame := PanelContainer.new()
			var box := StyleBoxFlat.new()
			box.bg_color = Color.TRANSPARENT
			box.border_color = INK
			box.set_border_width_all(3)
			box.content_margin_left = 18
			box.content_margin_right = 18
			box.content_margin_top = 8
			box.content_margin_bottom = 8
			frame.add_theme_stylebox_override("panel", box)
			frame.add_child(name_label)
			var column := VBoxContainer.new()
			column.add_theme_constant_override("separation", 8)
			sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			column.add_child(frame)
			column.add_child(sub)
			tile.add_child(column)
		_:
			# "plain": the name over a thin rule.
			var column := VBoxContainer.new()
			column.add_theme_constant_override("separation", 6)
			name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			var rule := ColorRect.new()
			rule.color = INK
			rule.custom_minimum_size = Vector2(0, 2)
			column.add_child(name_label)
			column.add_child(rule)
			column.add_child(sub)
			tile.add_child(column)
	return tile


## One logo's mark, drawn with lines and shapes inside its own square.
class Mark extends Control:
	const INK := Color(0.93, 0.94, 0.96)
	var kind := ""

	func _draw() -> void:
		var s := minf(size.x, size.y)
		var c := Vector2(s, s) / 2.0
		var w := maxf(s * 0.055, 2.0)
		match kind:
			"bulb":
				# A light bulb holding up a beam.
				draw_arc(c + Vector2(0, -s * 0.06), s * 0.27, deg_to_rad(130), deg_to_rad(410), 40, INK, w, true)
				for i in 3:
					draw_line(c + Vector2(-s * 0.13, s * (0.22 + i * 0.07)),
						c + Vector2(s * 0.13, s * (0.22 + i * 0.07)), INK, w, true)
				draw_rect(Rect2(s * 0.05, s * 0.02, s * 0.9, s * 0.09), INK)
			"rod":
				# A connecting rod with a bend it should not have.
				draw_arc(Vector2(s * 0.2, s * 0.68), s * 0.15, 0, TAU, 32, INK, w, true)
				draw_arc(Vector2(s * 0.82, s * 0.26), s * 0.09, 0, TAU, 24, INK, w, true)
				draw_polyline(PackedVector2Array([Vector2(s * 0.31, s * 0.58), Vector2(s * 0.5, s * 0.52),
					Vector2(s * 0.56, s * 0.3), Vector2(s * 0.74, s * 0.29)]), INK, w * 1.6, true)
			"tape":
				# A roll of tape with the end hanging off.
				draw_arc(c, s * 0.34, 0, TAU, 48, INK, w * 2.2, true)
				draw_arc(c, s * 0.13, 0, TAU, 32, INK, w, true)
				draw_line(c + Vector2(s * 0.34, 0), c + Vector2(s * 0.34, s * 0.46), INK, w * 2.2, true)
			"belt":
				# A belt round two pulleys, broken.
				draw_arc(Vector2(s * 0.27, c.y), s * 0.2, deg_to_rad(90), deg_to_rad(270), 24, INK, w, true)
				draw_arc(Vector2(s * 0.73, c.y), s * 0.2, deg_to_rad(-90), deg_to_rad(90), 24, INK, w, true)
				draw_line(Vector2(s * 0.27, c.y - s * 0.2), Vector2(s * 0.73, c.y - s * 0.2), INK, w, true)
				draw_line(Vector2(s * 0.27, c.y + s * 0.2), Vector2(s * 0.44, c.y + s * 0.2), INK, w, true)
				draw_line(Vector2(s * 0.56, c.y + s * 0.26), Vector2(s * 0.73, c.y + s * 0.2), INK, w, true)
				draw_circle(Vector2(s * 0.27, c.y), s * 0.06, INK)
				draw_circle(Vector2(s * 0.73, c.y), s * 0.06, INK)
			"five":
				# Five of something, in order of height.
				for i in 5:
					var h := s * (0.3 + i * 0.13)
					draw_rect(Rect2(s * (0.06 + i * 0.185), s * 0.92 - h, s * 0.13, h), INK)
			"cookie":
				# A cookie with a bite out of it, giving off no signal.
				draw_arc(c, s * 0.36, deg_to_rad(-20), deg_to_rad(285), 48, INK, w, true)
				draw_arc(c + Vector2(s * 0.3, -s * 0.24), s * 0.16, deg_to_rad(70), deg_to_rad(215), 20, INK, w, true)
				for p: Vector2 in [Vector2(-0.14, -0.1), Vector2(0.08, 0.02), Vector2(-0.08, 0.16),
						Vector2(0.16, 0.2), Vector2(-0.22, 0.06)]:
					draw_circle(c + p * s, s * 0.045, INK)
			"layers":
				# The same square, printed twice.
				draw_rect(Rect2(s * 0.1, s * 0.1, s * 0.58, s * 0.58), INK, false, w)
				draw_rect(Rect2(s * 0.3, s * 0.3, s * 0.58, s * 0.58), INK, false, w)
				for i in 4:
					draw_line(Vector2(s * 0.3, s * (0.42 + i * 0.12)), Vector2(s * 0.88, s * (0.42 + i * 0.12)),
						Color(INK, 0.5), 1.0)
			"calendar":
				# A calendar with most of the days crossed out.
				draw_rect(Rect2(s * 0.08, s * 0.14, s * 0.84, s * 0.78), INK, false, w)
				draw_rect(Rect2(s * 0.08, s * 0.14, s * 0.84, s * 0.16), INK)
				for row in 3:
					for col in 4:
						var at := Vector2(s * (0.2 + col * 0.2), s * (0.44 + row * 0.16))
						if (row * 4 + col) % 5 == 3:
							draw_circle(at, s * 0.035, INK)
						else:
							draw_line(at - Vector2(s, s) * 0.04, at + Vector2(s, s) * 0.04, INK, 1.5, true)
							draw_line(at + Vector2(-s, s) * 0.04, at + Vector2(s, -s) * 0.04, INK, 1.5, true)
			"podium":
				# A podium where first place is very small.
				draw_rect(Rect2(s * 0.06, s * 0.5, s * 0.27, s * 0.42), INK)
				draw_rect(Rect2(s * 0.365, s * 0.84, s * 0.27, s * 0.08), INK)
				draw_rect(Rect2(s * 0.67, s * 0.62, s * 0.27, s * 0.3), INK)
				draw_circle(Vector2(s * 0.5, s * 0.7), s * 0.07, INK)
			"cage":
				# A roll cage, seen from the side.
				draw_polyline(PackedVector2Array([Vector2(s * 0.1, s * 0.9), Vector2(s * 0.2, s * 0.3),
					Vector2(s * 0.42, s * 0.1), Vector2(s * 0.74, s * 0.1), Vector2(s * 0.9, s * 0.5),
					Vector2(s * 0.9, s * 0.9)]), INK, w * 1.4, true)
				draw_line(Vector2(s * 0.2, s * 0.3), Vector2(s * 0.9, s * 0.9), INK, w, true)
				draw_line(Vector2(s * 0.74, s * 0.1), Vector2(s * 0.2, s * 0.62), INK, w, true)
				draw_line(Vector2(s * 0.42, s * 0.1), Vector2(s * 0.42, s * 0.9), INK, w, true)
			"spray":
				# A nozzle going off when nobody asked it to.
				draw_rect(Rect2(s * 0.08, s * 0.42, s * 0.24, s * 0.16), INK)
				for i in 16:
					var along := 0.36 + (i % 4) * 0.15
					var spread := (int(i / 4.0) - 1.5) * 0.11 * (1.0 + (i % 4) * 0.55)
					draw_circle(Vector2(s * along, s * (0.5 + spread)), s * (0.022 + (i % 4) * 0.008), INK)
			"sock":
				# A filter sock on the end of a fuel line.
				draw_line(Vector2(s * 0.1, s * 0.2), Vector2(s * 0.5, s * 0.2), INK, w * 1.6, true)
				draw_polyline(PackedVector2Array([Vector2(s * 0.5, s * 0.12), Vector2(s * 0.62, s * 0.12),
					Vector2(s * 0.62, s * 0.62), Vector2(s * 0.9, s * 0.72), Vector2(s * 0.86, s * 0.9),
					Vector2(s * 0.42, s * 0.9), Vector2(s * 0.42, s * 0.3), Vector2(s * 0.5, s * 0.3),
					Vector2(s * 0.5, s * 0.12)]), INK, w, true)
				for i in 4:
					draw_line(Vector2(s * 0.44, s * (0.4 + i * 0.12)), Vector2(s * 0.6, s * (0.4 + i * 0.12)),
						Color(INK, 0.6), 1.5, true)
			"fall":
				# Someone on their way down, not having been pushed.
				draw_circle(Vector2(s * 0.62, s * 0.2), s * 0.09, INK)
				draw_polyline(PackedVector2Array([Vector2(s * 0.3, s * 0.18), Vector2(s * 0.56, s * 0.36),
					Vector2(s * 0.5, s * 0.6), Vector2(s * 0.72, s * 0.78)]), INK, w * 1.3, true)
				draw_line(Vector2(s * 0.5, s * 0.6), Vector2(s * 0.26, s * 0.66), INK, w * 1.3, true)
				draw_line(Vector2(s * 0.56, s * 0.36), Vector2(s * 0.84, s * 0.42), INK, w * 1.3, true)
				for i in 3:
					draw_line(Vector2(s * (0.1 + i * 0.07), s * 0.3), Vector2(s * (0.1 + i * 0.07), s * 0.05),
						Color(INK, 0.6), 1.5, true)
				draw_line(Vector2(s * 0.08, s * 0.94), Vector2(s * 0.92, s * 0.94), INK, w, true)
			"road":
				# A road to the parts shop, again.
				draw_polyline(PackedVector2Array([Vector2(s * 0.08, s * 0.92), Vector2(s * 0.44, s * 0.14),
					Vector2(s * 0.56, s * 0.14), Vector2(s * 0.92, s * 0.92)]), INK, w, true)
				for i in 4:
					var y := 0.24 + i * 0.18
					draw_line(Vector2(s * 0.5, s * y), Vector2(s * 0.5, s * (y + 0.08 + i * 0.01)), INK, w, true)
			"diamond":
				# A diamond held together with tape.
				draw_polyline(PackedVector2Array([Vector2(s * 0.5, s * 0.92), Vector2(s * 0.06, s * 0.36),
					Vector2(s * 0.26, s * 0.1), Vector2(s * 0.74, s * 0.1), Vector2(s * 0.94, s * 0.36),
					Vector2(s * 0.5, s * 0.92)]), INK, w, true)
				draw_line(Vector2(s * 0.06, s * 0.36), Vector2(s * 0.94, s * 0.36), INK, w * 0.7, true)
				draw_line(Vector2(s * 0.18, s * 0.66), Vector2(s * 0.82, s * 0.5), INK, w * 2.4)
			"can":
				# A spray can, mid-coat.
				draw_rect(Rect2(s * 0.14, s * 0.3, s * 0.34, s * 0.62), INK)
				draw_rect(Rect2(s * 0.24, s * 0.16, s * 0.14, s * 0.14), INK, false, w)
				for i in 9:
					draw_circle(Vector2(s * (0.56 + (i % 3) * 0.13), s * (0.1 + int(i / 3.0) * 0.1 + (i % 3) * 0.02)),
						s * 0.028, INK)
			"pizza":
				# One slice, offered up.
				draw_polyline(PackedVector2Array([Vector2(s * 0.5, s * 0.94), Vector2(s * 0.1, s * 0.2),
					Vector2(s * 0.9, s * 0.2), Vector2(s * 0.5, s * 0.94)]), INK, w, true)
				draw_arc(Vector2(s * 0.5, s * 0.36), s * 0.44, deg_to_rad(202), deg_to_rad(338), 24, INK, w * 1.6, true)
				for p: Vector2 in [Vector2(0.4, 0.38), Vector2(0.6, 0.42), Vector2(0.5, 0.62)]:
					draw_circle(p * s, s * 0.055, INK)
			"trailer":
				# A car on a trailer, which is how it likes to travel.
				draw_line(Vector2(s * 0.02, s * 0.74), Vector2(s * 0.9, s * 0.74), INK, w * 1.4, true)
				draw_line(Vector2(s * 0.9, s * 0.74), Vector2(s * 0.98, s * 0.6), INK, w, true)
				draw_circle(Vector2(s * 0.3, s * 0.86), s * 0.08, INK)
				draw_circle(Vector2(s * 0.48, s * 0.86), s * 0.08, INK)
				draw_polyline(PackedVector2Array([Vector2(s * 0.1, s * 0.66), Vector2(s * 0.14, s * 0.5),
					Vector2(s * 0.3, s * 0.46), Vector2(s * 0.42, s * 0.32), Vector2(s * 0.64, s * 0.32),
					Vector2(s * 0.74, s * 0.48), Vector2(s * 0.86, s * 0.52), Vector2(s * 0.86, s * 0.66),
					Vector2(s * 0.1, s * 0.66)]), INK, w, true)
			"flag":
				# A chequered flag, struck through.
				for row in 3:
					for col in 3:
						if (row + col) % 2 == 0:
							draw_rect(Rect2(s * (0.14 + col * 0.24), s * (0.14 + row * 0.24), s * 0.24, s * 0.24), INK)
				draw_rect(Rect2(s * 0.14, s * 0.14, s * 0.72, s * 0.72), INK, false, w)
				draw_line(Vector2(s * 0.04, s * 0.96), Vector2(s * 0.96, s * 0.04), Color(0.02, 0.022, 0.03), w * 3.2, true)
				draw_line(Vector2(s * 0.04, s * 0.96), Vector2(s * 0.96, s * 0.04), INK, w * 1.3, true)
