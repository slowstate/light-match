extends Node

const WINDOW_MODE_LABELS = {DisplayServer.WINDOW_MODE_FULLSCREEN: "Fullscreen", DisplayServer.WINDOW_MODE_WINDOWED: "Windowed"}

var window_mode := DisplayServer.WINDOW_MODE_FULLSCREEN
var windowed_mode_resolution := Vector2i(1920, 1080)


func _ready() -> void:
	pass
	# Get screen size and set

	# Load window_mode from settings
	#DisplayServer.window_set_mode(window_mode)

	# If window_mode == WINDOWED: Load windowed_mode_resolution_options and set windowed_mode_resolution


func set_window_mode(new_window_mode: int) -> void:
	window_mode = new_window_mode
	DisplayServer.window_set_mode(window_mode)
	if window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_size(windowed_mode_resolution)


func set_windowed_resolution(new_resolution: Vector2i) -> void:
	windowed_mode_resolution = new_resolution
	var viewport = get_viewport()
	DisplayServer.window_set_size(windowed_mode_resolution)


func get_window_mode_windowed_options() -> Array[Vector2i]:
	var windowed_mode_resolution_options: Array[Vector2i] = []
	var screen_size = DisplayServer.screen_get_size()
	#windowed_mode_resolution_options.push_back(screen_size)
	if screen_size.x > 1920 and screen_size.y > 1080:
		windowed_mode_resolution_options.push_back(Vector2i(1920, 1080))
	if screen_size.x > 1280 and screen_size.y > 720:
		windowed_mode_resolution_options.push_back(Vector2i(1280, 720))
	return windowed_mode_resolution_options
