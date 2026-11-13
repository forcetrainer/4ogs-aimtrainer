extends SceneTree
## Offline tool: measures a music track so it can be looped: where the sound
## starts, how loud each stretch is, how the end tails off, and the tempo.
## Run: godot --headless --path game --script res://tests/tools_music_analyse.gd

const PATH := "res://assets/audio/music/menu_theme.mp3"


func _init() -> void:
	var stream := AudioStreamMP3.load_from_file(ProjectSettings.globalize_path(PATH))
	var rate := int(AudioServer.get_mix_rate())
	var playback := stream.instantiate_playback()
	playback.start(0.0)
	var total := int(stream.get_length() * rate)
	var hop := rate / 100
	var env := PackedFloat32Array()
	var done := 0
	while done < total:
		var frames: PackedVector2Array = playback.mix_audio(1.0, mini(hop * 50, total - done))
		if frames.is_empty():
			break
		var i := 0
		while i + hop <= frames.size():
			var sum := 0.0
			for k in hop:
				var f := frames[i + k]
				sum += f.x * f.x + f.y * f.y
			env.append(sqrt(sum / (hop * 2)))
			i += hop
		done += frames.size()
	print("MUSIC length %.2f s, %d envelope points, rate %d" % [stream.get_length(), env.size(), rate])
	var peak := 0.0
	for v in env:
		peak = maxf(peak, v)
	var first := 0
	while first < env.size() and env[first] < peak * 0.05:
		first += 1
	print("MUSIC sound starts at %.2f s; loudest 10 ms is %.3f" % [first / 100.0, peak])
	var line := "MUSIC level per 5 s:"
	for start in range(0, env.size(), 500):
		var s := 0.0
		var n := 0
		for i in range(start, mini(start + 500, env.size())):
			s += env[i]
			n += 1
		line += " %.3f" % (s / maxi(n, 1))
	print(line)
	line = "MUSIC last 8 s per second:"
	for start in range(env.size() - 800, env.size(), 100):
		var s := 0.0
		for i in range(start, start + 100):
			s += env[i]
		line += " %.3f" % (s / 100.0)
	print(line)
	# Tempo: how regularly the level jumps.
	var flux := PackedFloat32Array()
	flux.resize(env.size())
	for i in range(1, env.size()):
		flux[i] = maxf(env[i] - env[i - 1], 0.0)
	var best_lag := 0
	var best := 0.0
	for lag in range(30, 121):
		var s := 0.0
		for i in range(1000, env.size() - lag - 1000):
			s += flux[i] * flux[i + lag]
		if s > best:
			best = s
			best_lag = lag
	print("MUSIC strongest beat spacing %.2f s (%.1f per minute)" % [best_lag / 100.0, 6000.0 / best_lag])
	quit()
