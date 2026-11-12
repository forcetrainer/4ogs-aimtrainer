extends RefCounted
## What gets written to disk: one row per target in a per-session file, and
## one row per finished run in the long-term history.

const Config = preload("res://scripts/config.gd")

const HISTORY_PATH := "user://history_v3.csv"
const TARGET_HEADER := "unix_time,drill,fov,sensitivity,dpi,enemy_ttk_ms,fight,fight_won," + \
	"stack_index,zone,stance,offset_deg,visual_angle_deg,direction_deg,height_m," + \
	"flick_deg,distance_m,in_view_at_spawn," + \
	"pre_ads,react_ms,in_view_ms,ads_ms,first_shot_ms,first_hit_ms,kill_ms,shots,hits," + \
	"headshots,first_shot_error_deg,sight,from_cover,arena_seed"
const HISTORY_HEADER := "unix_time,drill,sight,fov,sensitivity,dpi,fights,wins,enemy_ttk_start_ms," + \
	"enemy_ttk_end_ms,median_react_ms,median_first_shot_ms,median_first_hit_ms," + \
	"median_kill_ms,hit_rate_pct,arena_seed"

var _file: FileAccess


func open() -> void:
	var dir := ProjectSettings.globalize_path("user://telemetry")
	DirAccess.make_dir_recursive_absolute(dir)
	_file = FileAccess.open("%s/engagements_%d.csv" % [dir, _now()], FileAccess.WRITE)
	if _file:
		_file.store_line(TARGET_HEADER)


static func target_row(rec: Dictionary, won: bool, drill_id: String, settings: Dictionary,
		fight_ttk: float, fight_number: int, unix_time: int) -> String:
	return ",".join([
		str(unix_time), drill_id, str(settings.fov),
		str(settings.sensitivity), str(settings.dpi), "%.0f" % fight_ttk, str(fight_number),
		str(int(won)), str(rec.stack_index), rec.zone, rec.stance, "%.1f" % rec.offset,
		"%.1f" % rec.ecc, "%.0f" % rec.direction, "%.1f" % rec.height, "%.1f" % rec.flick_deg,
		"%.1f" % rec.distance, str(int(rec.in_view_at_spawn)),
		str(int(rec.pre_ads)), "%.1f" % rec.react, "%.1f" % rec.in_view, "%.1f" % rec.ads,
		"%.1f" % rec.first_shot, "%.1f" % rec.first_hit, "%.1f" % rec.kill, str(rec.shots),
		str(rec.hits), str(rec.headshots), "%.2f" % rec.first_shot_error, rec.sight,
		str(int(rec.get("from_cover", false))), str(rec.get("arena_seed", 0))])


func write_target(rec: Dictionary, won: bool, drill_id: String, settings: Dictionary,
		fight_ttk: float, fight_number: int) -> void:
	if not _file:
		return
	_file.store_line(target_row(rec, won, drill_id, settings, fight_ttk, fight_number, _now()))
	_file.flush()


## Add one finished run to the history. `stats` comes from Summary.stats().
static func history_row(drill_id: String, sight: String, settings: Dictionary, fights: int,
		wins: int, ttk_start: float, ttk_end: float, stats: Dictionary, unix_time: int) -> String:
	var stage: Dictionary = stats.stage
	return "%d,%s,%s,%s,%s,%s,%d,%d,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.1f,%d" % [
		unix_time, drill_id, sight, str(settings.fov),
		str(settings.sensitivity), str(settings.dpi), fights, wins, ttk_start, ttk_end,
		Config.median(stage.react), Config.median(stage.first_shot),
		Config.median(stage.first_hit), Config.median(stage.kill), stats.hit_rate,
		stats.get("arena_seed", 0)]


## Past runs of one drill with the same sight and FOV, oldest first, as
## {"date", "level"} where level is the enemy time-to-kill the run ended on.
static func earlier_runs(csv_text: String, drill_id: String, sight: String, fov: float) -> Array:
	var out := []
	var bias: int = int(Time.get_time_zone_from_system().bias) * 60
	for line: String in csv_text.split("\n", false).slice(1):
		var c := line.strip_edges().split(",")
		if c.size() < 10 or c[1] != drill_id or c[2] != sight \
				or not is_equal_approx(float(c[3]), fov):
			continue
		out.append({"date": Time.get_date_string_from_unix_time(int(c[0]) + bias),
			"level": float(c[9])})
	return out


static func read_history_file() -> String:
	return FileAccess.get_file_as_string(HISTORY_PATH) if FileAccess.file_exists(HISTORY_PATH) else ""


static func append_history(drill_id: String, sight: String, settings: Dictionary, fights: int,
		wins: int, ttk_start: float, ttk_end: float, stats: Dictionary) -> void:
	var is_new := not FileAccess.file_exists(HISTORY_PATH)
	var f := FileAccess.open(HISTORY_PATH, FileAccess.WRITE if is_new else FileAccess.READ_WRITE)
	if not f:
		return
	if is_new:
		f.store_line(HISTORY_HEADER)
	f.seek_end()
	f.store_line(history_row(drill_id, sight, settings, fights, wins, ttk_start, ttk_end,
		stats, _now()))


static func _now() -> int:
	return int(Time.get_unix_time_from_system())


# ---------- session checks ----------

const CHECKS_PATH := "user://checks.csv"
const CHECK_HEADER := "unix_time,version,cold,sight,fov,sensitivity,dpi,targets,kills," + \
	"score_ms,median_react_ms,median_first_shot_ms,median_first_hit_ms,hit_rate_pct"


## `result` comes from Summary.check_result(). `cold` is true only for the
## first check after starting the game.
static func check_row(version: int, cold: bool, sight: String, settings: Dictionary,
		result: Dictionary, unix_time: int) -> String:
	var stage: Dictionary = result.stats.stage
	return "%d,%d,%d,%s,%s,%s,%s,%d,%d,%.0f,%.0f,%.0f,%.0f,%.1f" % [
		unix_time, version, int(cold), sight, str(settings.fov), str(settings.sensitivity),
		str(settings.dpi), result.targets, result.kills, result.score,
		Config.median(stage.react), Config.median(stage.first_shot),
		Config.median(stage.first_hit), result.stats.hit_rate]


static func append_check(version: int, cold: bool, sight: String, settings: Dictionary,
		result: Dictionary) -> void:
	var is_new := not FileAccess.file_exists(CHECKS_PATH)
	var f := FileAccess.open(CHECKS_PATH, FileAccess.WRITE if is_new else FileAccess.READ_WRITE)
	if not f:
		return
	if is_new:
		f.store_line(CHECK_HEADER)
	f.seek_end()
	f.store_line(check_row(version, cold, sight, settings, result, _now()))


## Past cold checks of this version taken with the same sight and FOV, oldest
## first, as {"date", "score"}. Results at other settings are not comparable.
static func earlier_checks(csv_text: String, version: int, sight: String, fov: float) -> Array:
	var out := []
	var bias: int = int(Time.get_time_zone_from_system().bias) * 60
	for line: String in csv_text.split("\n", false).slice(1):
		var c := line.strip_edges().split(",")
		if c.size() < 10 or int(c[1]) != version or c[2] != "1" or c[3] != sight \
				or not is_equal_approx(float(c[4]), fov):
			continue
		out.append({"date": Time.get_date_string_from_unix_time(int(c[0]) + bias),
			"score": float(c[9])})
	return out


static func read_checks_file() -> String:
	return FileAccess.get_file_as_string(CHECKS_PATH) if FileAccess.file_exists(CHECKS_PATH) else ""
