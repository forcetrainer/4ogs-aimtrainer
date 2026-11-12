extends Node
## The shell around the drill: splash, main menu, practice list and settings.
## It starts the drill and takes the player back to the menu when they leave.
##
## Development aid: "-- --show=<screen> --screenshot=<path>" opens one screen
## (splash, menu, practice, settings, briefing, play, results, pause), saves
## a picture of it and quits. "--screenshot" alone, or "--no-check", goes
## straight into the saved practice drill as before.

const Style = preload("res://scripts/ui/style.gd")
const Config = preload("res://scripts/config.gd")
const RunLog = preload("res://scripts/run_log.gd")
const World = preload("res://scripts/world.gd")
const Engagement = preload("res://scripts/engagement.gd")
const SettingsMenu = preload("res://scripts/ui/settings_menu.gd")

const AUDIO_TEST := "res://tests/audio_test.tscn"
const DRILLS := ["mixed", "peripheral", "offscreen"]
const SPLASH_SECONDS := 4.0

var settings := {}

var _root: Control
var _screen: Control
var _backdrop: Node3D
var _backdrop_camera: Camera3D
var _game: Node
var _splash_left := 0.0
var _describe: Label


func _ready() -> void:
	settings = Config.load_settings()
	Config.refresh_monitor(settings, false)
	_fit_scale()
	get_window().size_changed.connect(_fit_scale)

	var layer := CanvasLayer.new()
	layer.layer = 5
	add_child(layer)
	_root = Control.new()
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.theme = Style.theme()
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(_root)

	var show := ""
	var shot := ""
	var args := OS.get_cmdline_user_args()
	for arg: String in args:
		if arg.begins_with("--show="):
			show = arg.trim_prefix("--show=")
		elif arg.begins_with("--screenshot="):
			shot = arg.trim_prefix("--screenshot=")
	if show == "" and (shot != "" or "--no-check" in args):
		_start_game(settings.get("drill", "mixed"))
		return
	match show:
		"cover":
			_start_game(settings.get("drill", "mixed"), show)
		"briefing", "play", "pause":
			_start_game("check", show)
		"results":
			_start_game(settings.get("drill", "mixed"), show)
		"menu":
			_build_backdrop()
			_show_menu()
		"practice":
			_build_backdrop()
			_show_practice()
		"settings":
			_build_backdrop()
			_show_settings()
		_:
			_build_backdrop()
			_show_splash()
	if shot != "":
		await get_tree().create_timer(1.2).timeout
		get_viewport().get_texture().get_image().save_png(shot)
		get_tree().quit()


## Menus are laid out for a screen 1080 units tall and scaled to fit.
func _fit_scale() -> void:
	get_window().content_scale_factor = maxf(get_window().size.y / 1080.0, 0.5)


func _process(delta: float) -> void:
	if _backdrop_camera:
		_backdrop_camera.rotate_y(-delta * 0.035)
	if _splash_left > 0.0:
		_splash_left -= delta
		if _splash_left <= 0.0:
			_show_menu()


func _input(event: InputEvent) -> void:
	if _game:
		return
	var pressed: bool = (event is InputEventKey or event is InputEventMouseButton) \
		and event.pressed
	if _splash_left > 0.0:
		if pressed:
			get_viewport().set_input_as_handled()
			_show_menu()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE \
			and _screen and _screen.has_meta("sub"):
		_show_menu()


# ---------- backdrop ----------

## The drill's world, turning slowly behind the menus.
func _build_backdrop() -> void:
	_backdrop = Node3D.new()
	add_child(_backdrop)
	World.build(_backdrop)
	_backdrop_camera = Camera3D.new()
	_backdrop_camera.position = Vector3(0, 1.7, 0)
	_backdrop_camera.rotation_degrees = Vector3(4, 30, 0)
	_backdrop_camera.fov = 60
	_backdrop.add_child(_backdrop_camera)
	_backdrop_camera.make_current()


func _drop_backdrop() -> void:
	if _backdrop:
		_backdrop.queue_free()
	_backdrop = null
	_backdrop_camera = null


# ---------- screens ----------

func _set_screen(screen: Control, sub: bool) -> void:
	if _screen:
		_screen.queue_free()
	_splash_left = 0.0
	_screen = screen
	if sub:
		screen.set_meta("sub", true)
	_root.add_child(screen)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _full() -> Control:
	var c := Control.new()
	c.set_anchors_preset(Control.PRESET_FULL_RECT)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c


func _spacer(height: float) -> Control:
	var c := Control.new()
	c.custom_minimum_size.y = height
	return c


## Darkens the backdrop: nearly solid behind the menu, clearer to the right.
func _shade() -> TextureRect:
	var g := Gradient.new()
	g.set_color(0, Color(Style.BG, 0.97))
	g.set_color(1, Color(Style.BG, 0.35))
	g.set_offset(0, 0.18)
	g.set_offset(1, 0.85)
	var tex := GradientTexture2D.new()
	tex.gradient = g
	tex.width = 256
	tex.height = 4
	var rect := TextureRect.new()
	rect.texture = tex
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_SCALE
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rect


## The left-hand column every menu screen is built in.
func _column(screen: Control) -> VBoxContainer:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 150)
	margin.add_theme_constant_override("margin_top", 110)
	margin.add_theme_constant_override("margin_bottom", 60)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	screen.add_child(margin)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 6)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(col)
	return col


## A menu item. Its description appears under the list while it is
## highlighted.
func _item(col: VBoxContainer, text: String, description: String, action: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.custom_minimum_size.x = 440
	b.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	b.pressed.connect(action)
	var tell := func():
		if is_instance_valid(_describe):
			_describe.text = description
	b.focus_entered.connect(tell)
	b.mouse_entered.connect(func(): b.grab_focus())
	col.add_child(b)
	return b


func _description(col: VBoxContainer) -> void:
	col.add_child(_spacer(16))
	_describe = Style.label("", 19, Style.DIM)
	_describe.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_describe.custom_minimum_size = Vector2(620, 80)
	_describe.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	col.add_child(_describe)


func _show_splash() -> void:
	var screen := _full()
	var bg := ColorRect.new()
	bg.color = Style.BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	screen.add_child(bg)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	screen.add_child(center)
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 26)
	center.add_child(stack)
	stack.add_child(Style.logo(620))
	var tag := Style.side_quest_tag()
	tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stack.add_child(tag)
	var name_label := Style.title("AIM TRAINER", 40)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stack.add_child(name_label)
	var prompt := Style.label("PRESS ANY KEY", 18, Style.DIM)
	prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	prompt.offset_top = -110
	prompt.offset_bottom = -80
	screen.add_child(prompt)
	_set_screen(screen, false)
	_splash_left = SPLASH_SECONDS
	screen.modulate.a = 0.0
	create_tween().tween_property(screen, "modulate:a", 1.0, 0.7)
	var pulse := create_tween().bind_node(prompt).set_loops()
	pulse.tween_property(prompt, "modulate:a", 0.35, 0.9)
	pulse.tween_property(prompt, "modulate:a", 1.0, 0.9)


func _header(col: VBoxContainer, heading: String) -> void:
	var logo := Style.logo(300)
	logo.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	col.add_child(logo)
	col.add_child(_spacer(10))
	col.add_child(Style.side_quest_tag())
	col.add_child(Style.title(heading, 52))
	var bar := Style.gradient_bar(380, 3)
	bar.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	col.add_child(bar)
	col.add_child(_spacer(26))


func _footer(screen: Control, pairs: Array) -> void:
	var hints := Style.hints(pairs)
	hints.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	hints.offset_left = 150
	hints.offset_top = -70
	hints.offset_bottom = -44
	screen.add_child(hints)


func _show_menu() -> void:
	var screen := _full()
	screen.add_child(_shade())
	var col := _column(screen)
	_header(col, "AIM TRAINER")
	var first := _item(col, "START SESSION",
		"The session check, then practice. The check is the same short test every time, so it shows whether you are really getting better. " + _last_check(),
		func(): _start_game("check"))
	_item(col, "PRACTICE", "Go straight to a practice drill and skip the check.",
		_show_practice)
	_item(col, "SETTINGS", "Sensitivity, field of view, sight, and your screen.", _show_settings)
	_item(col, "SOUND TEST", "Check that you can tell where footsteps are coming from. Wear headphones.",
		_start_sound_test)
	_item(col, "QUIT", "", func(): get_tree().quit())
	_description(col)
	_footer(screen, [["ENTER", "SELECT"], ["UP / DOWN", "MOVE"]])
	_set_screen(screen, false)
	first.grab_focus.call_deferred()


func _last_check() -> String:
	var version := int(Config.load_json("res://drills/check.json").get("version", 1))
	var sight := "optic" if settings.get("optic", true) else "irons"
	var earlier := RunLog.earlier_checks(RunLog.read_checks_file(), version, sight, settings.fov)
	if earlier.is_empty():
		return "You have not taken one yet with this sight and field of view."
	var last: Dictionary = earlier.back()
	return "Last check: %d ms on %s." % [last.score, last.date]


func _show_practice() -> void:
	var screen := _full()
	screen.add_child(_shade())
	var col := _column(screen)
	_header(col, "PRACTICE")
	var first: Button
	for id: String in DRILLS:
		var drill := Config.load_json("res://drills/%s.json" % id)
		var level := ""
		if settings.has("enemy_ttk_ms_" + id):
			level = "  Your level: beating an enemy who kills in %d ms." % settings["enemy_ttk_ms_" + id]
		var b := _item(col, String(drill.name).to_upper(), "%s.%s" % [drill.goal, level],
			func(): _start_game(id))
		if first == null:
			first = b
	col.add_child(_spacer(12))
	_item(col, "BACK", "", _show_menu)
	_description(col)
	_footer(screen, [["ENTER", "SELECT"], ["ESC", "BACK"]])
	_set_screen(screen, true)
	first.grab_focus.call_deferred()


func _show_settings() -> void:
	var screen := _full()
	screen.add_child(_shade())
	var menu := SettingsMenu.new()
	menu.setup(settings)
	menu.closed.connect(_show_menu)
	screen.add_child(menu)
	_footer(screen, [["ESC", "BACK"]])
	_set_screen(screen, true)


# ---------- starting and leaving the drill ----------

func _clear_for_game() -> void:
	if _screen:
		_screen.queue_free()
		_screen = null
	_splash_left = 0.0
	_drop_backdrop()


func _start_game(mode: String, dev_show := "") -> void:
	_clear_for_game()
	var game := Engagement.new()
	game.mode = mode
	game.dev_show = dev_show
	game.exit_to_menu.connect(_back_from_game)
	_game = game
	add_child(game)


func _start_sound_test() -> void:
	_clear_for_game()
	var test: Node = load(AUDIO_TEST).instantiate()
	test.embedded = true
	test.exited.connect(_back_from_game)
	_game = test
	add_child(test)


func _back_from_game() -> void:
	if _game:
		_game.queue_free()
		_game = null
	settings = Config.load_settings()
	_build_backdrop()
	_show_menu()
