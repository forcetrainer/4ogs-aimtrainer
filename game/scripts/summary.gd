extends RefCounted
## Turns the per-target records of a fight or a run into numbers and text.
## Pure calculation: no nodes, no files.

const Config = preload("res://scripts/config.gd")
const Placement = preload("res://scripts/placement.gd")
const Target = preload("res://scripts/target.gd")


## One line shown after each fight.
static func fight_text(won: bool, fight_ttk: float, recs: Array, headline := "") -> String:
	var parts := [headline if headline != "" else ("WON" if won else "LOST  (enemy took %d ms)" % fight_ttk)]
	for rec: Dictionary in recs:
		var bits := ["%s, %s:" % [Placement.ZONE_NAMES[rec.zone], rec.stance]]
		for pair in [["react", "moved"], ["first_hit", "first hit"], ["kill", "kill"]]:
			if rec[pair[0]] >= 0.0:
				bits.append("%s %d ms" % [pair[1], rec[pair[0]]])
		bits.append("%d/%d hits" % [rec.hits, rec.shots])
		parts.append(" ".join(bits))
	return "      ".join(parts)


## Group a run's records. Times are lists of milliseconds, ready for a median.
##   stage:        react / first_shot / first_hit / kill, across all targets
##   zone_react:   time to first mouse movement, by reporting ring
##   zone_hit:     time to first hit, by reporting ring
##   level, steep: time to first movement for targets 5 to 15 deg out, to the
##                 side against above or below
##   stance_kill:  time from first hit to kill, by stance
static func stats(recs: Array) -> Dictionary:
	var shots := 0
	var hits := 0
	var stage := {"react": [], "first_shot": [], "first_hit": [], "kill": []}
	var zone_hit := {}
	var zone_react := {}
	var stance_kill := {}
	var level := []
	var steep := []
	for rec: Dictionary in recs:
		shots += rec.shots
		hits += rec.hits
		for key: String in stage:
			if rec[key] >= 0.0:
				stage[key].append(rec[key])
		if rec.react >= 0.0:
			zone_react.get_or_add(rec.zone, []).append(rec.react)
			# The screen reaches only about 16 deg up and down, so compare
			# directions at matched distances from the crosshair.
			if rec.ecc >= 5.0 and rec.ecc <= 15.0:
				var is_steep := absf(sin(deg_to_rad(rec.direction))) > 0.7
				(steep if is_steep else level).append(rec.react)
		if rec.first_hit >= 0.0:
			zone_hit.get_or_add(rec.zone, []).append(rec.first_hit)
		if rec.kill >= 0.0:
			stance_kill.get_or_add(rec.stance, []).append(rec.kill - rec.first_hit)
	return {
		"shots": shots, "hits": hits, "hit_rate": 100.0 * hits / maxi(shots, 1),
		"stage": stage, "zone_hit": zone_hit, "zone_react": zone_react,
		"stance_kill": stance_kill, "level": level, "steep": steep,
	}


## The end-of-run screen.
static func run_text(s: Dictionary, drill_name: String, wins: int, fights: int,
		ttk_now: float, ttk_start: float, earlier: Array = [], setup := "") -> String:
	var lines := [
		"%s: won %d of %d fights" % [drill_name, wins, fights],
		"",
		"Your level: beating an enemy who kills in %d ms" % ttk_now,
		"(started this run at %d ms; lower is better)" % ttk_start,
		"",
		"Typical time from the cue (median):",
		"   first mouse movement   %s" % fmt_ms(Config.median(s.stage.react)),
		"   first shot             %s" % fmt_ms(Config.median(s.stage.first_shot)),
		"   first hit              %s" % fmt_ms(Config.median(s.stage.first_hit)),
		"   kill                   %s" % fmt_ms(Config.median(s.stage.kill)),
		"Hit rate: %.0f%%" % s.hit_rate,
		"",
		"By distance from the crosshair in your vision:   noticed (first movement) / first hit",
	]
	for zone: String in Placement.ZONE_NAMES:
		if s.zone_hit.has(zone) or s.zone_react.has(zone):
			lines.append("   %-18s %8s / %-8s (%d targets)" % [
				Placement.ZONE_NAMES[zone], fmt_ms(Config.median(s.zone_react.get(zone, []))),
				fmt_ms(Config.median(s.zone_hit.get(zone, []))), s.zone_hit.get(zone, []).size()])
	lines.append("")
	lines.append("Noticed, for targets 5 to 15 deg out:")
	lines.append("   %-18s %8s  (%d targets)" % [
		"to the side", fmt_ms(Config.median(s.level)), s.level.size()])
	lines.append("   %-18s %8s  (%d targets)" % [
		"above or below", fmt_ms(Config.median(s.steep)), s.steep.size()])
	lines.append("")
	lines.append("Time from first hit to kill, by stance:")
	for stance: String in Target.STANCES:
		if s.stance_kill.has(stance):
			lines.append("   %-18s %s  (%d targets)" % [
				stance, fmt_ms(Config.median(s.stance_kill[stance])), s.stance_kill[stance].size()])
	if not earlier.is_empty():
		# `earlier` is {"date", "level"} for past runs of this drill at the
		# same sight and FOV, oldest first.
		lines.append("")
		lines.append("Level at the end of earlier runs with %s (most recent last):" % setup)
		var shown := []
		for e: Dictionary in earlier.slice(-6):
			shown.append("%d" % e.level)
		lines.append("   %s ms   (%d runs)" % [", ".join(shown), earlier.size()])
	return "\n".join(lines)


static func fmt_ms(value: float) -> String:
	return "-" if is_nan(value) else "%d ms" % value


## Result of a session check. A target that was not killed counts as the
## time limit, so giving up on hard targets cannot improve the score.
##   score: typical (median) time to kill, in ms; lower is better
static func check_result(recs: Array, timeout_ms: float) -> Dictionary:
	var times := []
	var kills := 0
	for rec: Dictionary in recs:
		if rec.kill >= 0.0:
			kills += 1
			times.append(rec.kill)
		else:
			times.append(timeout_ms)
	return {"targets": recs.size(), "kills": kills, "score": Config.median(times),
		"stats": stats(recs)}


## The end-of-check screen. `earlier` is a list of {"date", "score"} for past
## cold checks with the same sight and FOV, oldest first.
static func check_text(result: Dictionary, earlier: Array, sight_label: String, fov: float,
		timeout_ms: float, cold: bool) -> String:
	var s: Dictionary = result.stats
	var lines := [
		"Session check: killed %d of %d" % [result.kills, result.targets],
		"",
		"Typical time to kill: %s   (lower is better)" % fmt_ms(result.score),
		"A target you did not kill counts as %d ms." % timeout_ms,
		"",
		"Typical time from the cue (median):",
		"   first mouse movement   %s" % fmt_ms(Config.median(s.stage.react)),
		"   first shot             %s" % fmt_ms(Config.median(s.stage.first_shot)),
		"   first hit              %s" % fmt_ms(Config.median(s.stage.first_hit)),
		"Hit rate: %.0f%%" % s.hit_rate,
		"",
	]
	if not cold:
		lines.append("This was a repeat, so it is saved but not compared with your cold checks.")
		lines.append("")
	if earlier.is_empty():
		lines.append("No earlier checks with %s at FOV %d. This one is the starting point." % [
			sight_label, fov])
	else:
		lines.append("Earlier checks with %s at FOV %d (most recent last):" % [sight_label, fov])
		var best := INF
		for e: Dictionary in earlier:
			best = minf(best, e.score)
		for e: Dictionary in earlier.slice(-5):
			lines.append("   %s   %s" % [e.date, fmt_ms(e.score)])
		lines.append("   best so far   %s  (%d checks)" % [fmt_ms(best), earlier.size()])
	return "\n".join(lines)
