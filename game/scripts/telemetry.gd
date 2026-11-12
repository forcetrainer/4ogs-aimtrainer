extends RefCounted
## Append-only CSV log of every input event. Timestamps are when the event
## reached the script (microseconds since engine start), not when the mouse
## produced it; the frame column shows how events batch into frames.

var _file: FileAccess
var path := ""


func open() -> void:
	var dir := ProjectSettings.globalize_path("user://telemetry")
	DirAccess.make_dir_recursive_absolute(dir)
	path = "%s/session_%d.csv" % [dir, int(Time.get_unix_time_from_system())]
	_file = FileAccess.open(path, FileAccess.WRITE)
	if _file:
		_file.store_line("t_usec,frame,kind,dx,dy,yaw_deg,pitch_deg")


func log_event(kind: String, dx: float, dy: float, yaw: float, pitch: float) -> void:
	if _file:
		_file.store_line("%d,%d,%s,%d,%d,%.6f,%.6f" % [
			Time.get_ticks_usec(), Engine.get_process_frames(), kind, dx, dy, yaw, pitch])


func flush() -> void:
	if _file:
		_file.flush()


func close() -> void:
	if _file:
		_file.close()
		_file = null
