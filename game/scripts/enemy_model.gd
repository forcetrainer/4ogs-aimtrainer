extends Node3D
## The animated figure an enemy is drawn as, from Mixamo files. The files
## are one character with its skin and a set of animations for the same
## skeleton; they are joined here into one figure that can be told to
## stand, strafe, jump or die.
##
## Which animations exist decides what the figure can do. A stance with no
## animation (crouch and prone, until those files are added) is reported as
## unsupported, and the enemy falls back to its plain shape for it. Adding
## a file named in ANIMATIONS is all it takes to switch one on.
##
## Any Mixamo character works with these animations because they share a
## skeleton: put the one to use at assets/enemy/character.fbx and it
## replaces the default mannequin.

const Geo = preload("res://scripts/target_geometry.gd")

const DIR := "res://assets/enemy"
## Preferred first; the mannequin that comes with Mixamo packs is the fallback.
const CHARACTERS := ["character.fbx", "x_bot.fbx"]
## State -> [file, loops, keep in place].
const ANIMATIONS := {
	"idle": ["idle_aiming.fbx", true, true],
	"jump": ["rifle_jump.fbx", false, true],
	"crouch": ["idle_crouching_aiming.fbx", true, true],
	"prone": ["prone_idle.fbx", true, true],
	# The nearest thing to a drop shot in the library: crouch to prone.
	"drop": ["crouch_to_prone.fbx", false, true],
	"die": ["death_from_the_front.fbx", false, false],
	"die_2": ["dying_1.fbx", false, false],
	"die_head": ["death_from_front_headshot.fbx", false, false],
	"die_crouch": ["death_crouching_headshot_front.fbx", false, false],
	"die_prone": ["prone_death.fbx", false, false],
	# These two were made to carry the figure forward as it falls; held in
	# place so an enemy moving sideways does not lurch toward the player.
	"die_walk": ["walking_to_dying.fbx", false, true],
	"die_run": ["rifle_run_to_dying.fbx", false, true],
}
## Moving animations come in eight directions for each way of moving, with
## the figure facing the player throughout: toward them, away, to either
## side and the four diagonals. State names are "<gait>_<direction>", from
## files named "<prefix>_<direction>.fbx".
const GAITS := {"walk": "walk", "run": "run", "sprint": "sprint", "crouch": "walk_crouching"}
## In order round the compass, 45 degrees apart, starting with straight
## toward the player and turning to the figure's own left.
const DIRECTIONS := ["forward", "forward_left", "left", "backward_left", "backward",
	"backward_right", "right", "forward_right"]
## Ground speeds (m/s) at which an enemy changes from walking to running to
## sprinting.
const RUN_ABOVE := 2.9
const SPRINT_ABOVE := 5.2
## The mannequin is 1.81 m tall; enemies are judged as 1.74 m.
const HEIGHT_SCALE := 0.96

static var _library: AnimationLibrary
## Ground speed each moving animation was made for, measured from how far
## it carries the hips, so playback can be matched to the enemy's speed.
static var _made_for := {}
static var _character: PackedScene

var _player: AnimationPlayer
var _figure: Node3D
var _skeleton: Skeleton3D
var _state := ""


static func _character_path() -> String:
	for name: String in CHARACTERS:
		if ResourceLoader.exists("%s/%s" % [DIR, name]):
			return "%s/%s" % [DIR, name]
	return ""


## True if there is a character to draw and at least a standing animation.
static func available() -> bool:
	return _character_path() != "" \
		and ResourceLoader.exists("%s/%s" % [DIR, ANIMATIONS.idle[0]])


static func _load() -> void:
	if _library:
		return
	_character = load(_character_path())
	_library = AnimationLibrary.new()
	var wanted := ANIMATIONS.duplicate()
	for gait: String in GAITS:
		for direction: String in DIRECTIONS:
			wanted["%s_%s" % [gait, direction]] = ["%s_%s.fbx" % [GAITS[gait], direction], true, true]
	for state: String in wanted:
		var spec: Array = wanted[state]
		var path := "%s/%s" % [DIR, spec[0]]
		if not ResourceLoader.exists(path):
			continue
		var scene: Node = (load(path) as PackedScene).instantiate()
		var source: AnimationPlayer = scene.find_child("AnimationPlayer", true, false)
		if source and source.has_animation("mixamo_com"):
			var anim: Animation = source.get_animation("mixamo_com").duplicate()
			anim.loop_mode = Animation.LOOP_LINEAR if spec[1] else Animation.LOOP_NONE
			if spec[2]:
				_made_for[state] = _travel_speed(anim)
				_hold_in_place(anim)
			_library.add_animation(state, anim)
		scene.free()


## Mixamo animations carry the figure across the floor. The drill moves the
## enemy itself, so sideways and forward travel of the hips is taken out
## and only the bobbing up and down is kept.
static func _hold_in_place(anim: Animation) -> void:
	for track in anim.get_track_count():
		if anim.track_get_type(track) != Animation.TYPE_POSITION_3D:
			continue
		if not String(anim.track_get_path(track)).ends_with("Hips"):
			continue
		if anim.track_get_key_count(track) == 0:
			continue
		var first: Vector3 = anim.track_get_key_value(track, 0)
		for key in anim.track_get_key_count(track):
			var value: Vector3 = anim.track_get_key_value(track, key)
			anim.track_set_key_value(track, key, Vector3(first.x, value.y, first.z))


## How fast an animation carries the figure across the ground, in m/s at
## the figure's size in the game.
static func _travel_speed(anim: Animation) -> float:
	for track in anim.get_track_count():
		if anim.track_get_type(track) != Animation.TYPE_POSITION_3D:
			continue
		if not String(anim.track_get_path(track)).ends_with("Hips"):
			continue
		var keys := anim.track_get_key_count(track)
		if keys < 2 or anim.length <= 0.0:
			return 0.0
		var first: Vector3 = anim.track_get_key_value(track, 0)
		var last: Vector3 = anim.track_get_key_value(track, keys - 1)
		return Vector2(last.x - first.x, last.z - first.z).length() / anim.length * HEIGHT_SCALE
	return 0.0


## Ground speed an animation was made for, or 0 if it does not travel.
static func made_for(state: String) -> float:
	_load()
	return _made_for.get(state, 0.0)


## The moving animation for a speed and a direction of travel. `left` and
## `forward` are metres per second in the figure's own terms: to its left,
## and toward the player it is facing.
static func move_state(crouching: bool, left: float, forward: float) -> String:
	var speed := Vector2(left, forward).length()
	var gait := "walk"
	if crouching:
		gait = "crouch"
	elif speed > SPRINT_ABOVE:
		gait = "sprint"
	elif speed > RUN_ABOVE:
		gait = "run"
	var turn := rad_to_deg(atan2(left, forward))
	var sector := int(roundf(wrapf(turn, 0.0, 360.0) / 45.0)) % 8
	return "%s_%s" % [gait, DIRECTIONS[sector]]


static func supports(state: String) -> bool:
	if not available():
		return false
	_load()
	return _library.has_animation(state)


func _init() -> void:
	_load()
	var figure: Node3D = _character.instantiate()
	figure.scale = Vector3.ONE * HEIGHT_SCALE
	_figure = figure
	_skeleton = figure.find_child("Skeleton3D", true, false)
	add_child(figure)
	if _character_path().ends_with("x_bot.fbx"):
		# The stand-in mannequin is pale pink; give it a dull uniform colour
		# so it reads as a figure against the yard.
		var cloth := StandardMaterial3D.new()
		cloth.albedo_color = Color(0.2, 0.23, 0.19)
		cloth.roughness = 0.85
		for mesh: Node in figure.find_children("*", "MeshInstance3D", true, false):
			(mesh as MeshInstance3D).material_override = cloth
	var old := figure.find_child("AnimationPlayer", true, false)
	if old:
		old.free()
	_player = AnimationPlayer.new()
	figure.add_child(_player)
	_player.add_animation_library("", _library)
	play("idle")


## Switch to a state, blending from the last one. `speed` scales playback.
func play(state: String, speed := 1.0) -> void:
	if not _library.has_animation(state):
		return
	_player.speed_scale = speed
	if state != _state:
		_state = state
		_player.play(state, 0.15)


func length(state: String) -> float:
	return _library.get_animation(state).length if _library.has_animation(state) else 0.0


# ---------- hit regions ----------
#
# What a bullet can hit is a set of rounded tubes laid along the figure's
# bones, so it follows the animation: the head, the torso, each upper and
# lower arm, each thigh and shin. A soldier aiming a rifle holds his arms in
# front of his chest, so a shot at the chest may meet an arm first, as in
# the game.

## Region, bone at one end, bone at the other, radius in metres (at the
## figure's own size, before HEIGHT_SCALE).
const TUBES := [
	[Geo.BODY, "Hips", "Neck", 0.17],
	[Geo.ARM, "LeftArm", "LeftForeArm", 0.06],
	[Geo.ARM, "LeftForeArm", "LeftHand", 0.05],
	[Geo.ARM, "RightArm", "RightForeArm", 0.06],
	[Geo.ARM, "RightForeArm", "RightHand", 0.05],
	[Geo.LEG, "LeftUpLeg", "LeftLeg", 0.095],
	[Geo.LEG, "LeftLeg", "LeftFoot", 0.07],
	[Geo.LEG, "RightUpLeg", "RightLeg", 0.095],
	[Geo.LEG, "RightLeg", "RightFoot", 0.07],
]
const HEAD_RADIUS := 0.12
const BONE_PREFIX := "mixamorig_"


func _bone(owner_xf: Transform3D, bone_name: String) -> Vector3:
	var index := _skeleton.find_bone(BONE_PREFIX + bone_name)
	if index < 0:
		return owner_xf.origin
	return owner_xf * transform * _figure.transform * _skeleton.transform \
		* _skeleton.get_bone_global_pose(index).origin


## Every hit region where it is right now, as {"kind", "a", "b", "radius"}.
## `owner_xf` is the transform of the node this figure belongs to.
func regions(owner_xf: Transform3D) -> Array:
	var out := []
	var skull := _bone(owner_xf, "Head").lerp(_bone(owner_xf, "HeadTop_End"), 0.5)
	out.append({"kind": Geo.HEAD, "a": skull, "b": skull, "radius": HEAD_RADIUS * HEIGHT_SCALE})
	for tube: Array in TUBES:
		out.append({"kind": tube[0], "a": _bone(owner_xf, tube[1]), "b": _bone(owner_xf, tube[2]),
			"radius": float(tube[3]) * HEIGHT_SCALE})
	return out


## Which region a shot from `origin` along the unit vector `dir` meets
## first, or Geo.MISS.
func hit(owner_xf: Transform3D, origin: Vector3, dir: Vector3) -> int:
	var nearest := INF
	var kind: int = Geo.MISS
	for region: Dictionary in regions(owner_xf):
		var t := ray_tube(origin, dir, region.a, region.b, region.radius)
		if t < nearest:
			nearest = t
			kind = region.kind
	return kind


## How far along a ray it first enters a tube of `radius` round the line
## from a to b (a sphere when a and b are the same), or INF if it misses.
static func ray_tube(origin: Vector3, dir: Vector3, a: Vector3, b: Vector3, radius: float) -> float:
	var v := b - a
	var w := origin - a
	var along := dir.dot(v)
	var length_sq := v.dot(v)
	var d := dir.dot(w)
	var e := v.dot(w)
	var s := 0.0
	var denom := length_sq - along * along
	if denom > 1e-9:
		s = clampf((e - along * d) / denom, 0.0, 1.0)
	var t := along * s - d
	if t < 0.0:
		t = 0.0
		s = clampf(e / length_sq, 0.0, 1.0) if length_sq > 1e-9 else 0.0
	var gap := (w + dir * t - v * s).length()
	if gap > radius:
		return INF
	return maxf(t - sqrt(radius * radius - gap * gap), 0.0)
