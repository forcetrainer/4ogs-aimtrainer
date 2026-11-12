extends RefCounted
## Sensitivity and field-of-view math. All angles in degrees.
## One "count" is one unit of raw mouse movement as reported by the sensor.

const CM_PER_INCH := 2.54


static func degrees_per_count(yaw_constant: float, sensitivity: float) -> float:
	return yaw_constant * sensitivity


static func counts_per_360(yaw_constant: float, sensitivity: float) -> float:
	return 360.0 / degrees_per_count(yaw_constant, sensitivity)


static func cm_per_360(dpi: float, yaw_constant: float, sensitivity: float) -> float:
	return counts_per_360(yaw_constant, sensitivity) / dpi * CM_PER_INCH


static func sensitivity_for_cm_per_360(dpi: float, yaw_constant: float, cm: float) -> float:
	return 360.0 * CM_PER_INCH / (dpi * yaw_constant * cm)


static func counts_to_cm(counts: float, dpi: float) -> float:
	return counts / dpi * CM_PER_INCH


static func horizontal_to_vertical_fov(horizontal_deg: float, aspect: float) -> float:
	return rad_to_deg(2.0 * atan(tan(deg_to_rad(horizontal_deg) / 2.0) / aspect))


## FOV after zooming by a magnification factor (focal length scales with zoom).
static func zoomed_fov(fov_deg: float, zoom: float) -> float:
	return rad_to_deg(2.0 * atan(tan(deg_to_rad(fov_deg) / 2.0) / zoom))


## Sensitivity multiplier while aiming down sights, "relative" style, from the
## hip and ADS vertical FOVs and a monitor distance coefficient k.
## k = 0 is focal-length scaling. Community-derived formula.
static func relative_ads_multiplier(v_hip_deg: float, v_ads_deg: float, k: float) -> float:
	var th := tan(deg_to_rad(v_hip_deg) / 2.0)
	var ta := tan(deg_to_rad(v_ads_deg) / 2.0)
	if k <= 0.0:
		return ta / th
	return atan(k * ta) / atan(k * th)


## How large a target looks on screen at one FOV relative to another (linear).
static func on_screen_scale(fov_deg: float, reference_fov_deg: float) -> float:
	return tan(deg_to_rad(reference_fov_deg) / 2.0) / tan(deg_to_rad(fov_deg) / 2.0)


static func vertical_to_horizontal_fov(vertical_deg: float, aspect: float) -> float:
	return rad_to_deg(2.0 * atan(tan(deg_to_rad(vertical_deg) / 2.0) * aspect))
