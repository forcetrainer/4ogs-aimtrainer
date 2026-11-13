extends SceneTree
## Checks the logo wall's jokes behave: the keys it offers do not skip and
## cost time, the page that looks like the end is not, the offer moves to
## another key, and the unmentioned key really does skip.
## Run: godot --headless --path game --script res://tests/logo_wall_check.gd

const LogoWall = preload("res://scripts/ui/logo_wall.gd")

var _failures := 0
var _finished := 0


func _key(code: Key) -> InputEventKey:
	var e := InputEventKey.new()
	e.keycode = code
	e.pressed = true
	return e


func _expect(what: String, ok: bool) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	_failures += int(not ok)


func _initialize() -> void:
	var wall := LogoWall.new()
	wall.finished.connect(func(): _finished += 1)
	root.add_child(wall)
	await process_frame
	wall.set_process(false)  # time is stepped by hand below

	_expect("opens on the first page", wall._page == 0)
	_expect("first page offers space or escape", "SPACE" in wall._prompt.text)
	var before: float = wall._left
	wall._input(_key(KEY_SPACE))
	_expect("space does not skip", _finished == 0 and wall._page == 0)
	_expect("space is roasted", wall._roast.text == LogoWall.ROASTS[0])
	_expect("and costs time", wall._left > before)
	wall._input(_key(KEY_ESCAPE))
	_expect("escape gets a different roast", wall._roast.text == LogoWall.ROASTS[1])
	for i in 30:
		wall._input(_key(KEY_SPACE))
	_expect("the penalty is capped", wall._left <= LogoWall.PAGE_SECONDS * 2.0 + 0.001)

	# Let the first page run out.
	wall._process(LogoWall.PAGE_SECONDS * 2.0 + 1.0)
	_expect("the end of page one is not the end", _finished == 0 and wall._gotcha.visible)
	wall._input(_key(KEY_SPACE))
	_expect("nothing works during the gotcha", _finished == 0)
	wall._process(LogoWall.GOTCHA_SECONDS + 0.1)
	_expect("a second page follows", wall._page == 1 and not wall._gotcha.visible)
	_expect("the offer moved to another key", "P" in wall._prompt.text and not "SPACE" in wall._prompt.text)
	wall._input(_key(KEY_SPACE))
	_expect("the old key is mocked", wall._roast.text in LogoWall.WRONG_KEY_ROASTS)
	wall._input(_key(KEY_P))
	_expect("the new key does not skip either", _finished == 0 and wall._roast.text in LogoWall.ROASTS)
	wall._process(LogoWall.PAGE_SECONDS * 2.0 + 1.0)
	_expect("it does end after the second page", _finished == 1)

	# The key nobody is told about.
	var second := LogoWall.new()
	second.finished.connect(func(): _finished += 1)
	root.add_child(second)
	await process_frame
	second._input(_key(KEY_4))
	_expect("4 skips at once", _finished == 2)
	_expect("and 4 is never shown", not "4" in " ".join(LogoWall.CLAIMED_TEXT))

	print("LOGO WALL %s" % ("ok" if _failures == 0 else "FAILED: %d" % _failures))
	quit(1 if _failures else 0)
