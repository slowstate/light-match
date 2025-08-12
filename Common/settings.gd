extends Node

const WINDOW_MODE_LABELS = {
	DisplayServer.WINDOW_MODE_FULLSCREEN: "FULLSCREEN", DisplayServer.WINDOW_MODE_WINDOWED: "WINDOWED", DisplayServer.WINDOW_MODE_MAXIMIZED: "MAXIMISED"
}

var window_mode := DisplayServer.WINDOW_MODE_MAXIMIZED
var windowed_resolution: Array = [1920, 1080]
var screen_shake: bool

#region Control Mapping defaults
var control_mappings: Dictionary = {
	"player_next_colour": OS.get_keycode_string(KEY_E),
	"player_previous_colour": OS.get_keycode_string(KEY_Q),
	"player_blue": OS.get_keycode_string(KEY_1),
	"player_green": OS.get_keycode_string(KEY_2),
	"player_red": OS.get_keycode_string(KEY_3),
	"player_reload": OS.get_keycode_string(KEY_R),
	"player_move_up": OS.get_keycode_string(KEY_W),
	"player_move_down": OS.get_keycode_string(KEY_S),
	"player_move_left": OS.get_keycode_string(KEY_A),
	"player_move_right": OS.get_keycode_string(KEY_D),
}
#endregion


func set_window_mode(new_window_mode: int) -> void:
	window_mode = new_window_mode
	DisplayServer.window_set_mode(window_mode)


func set_windowed_resolution(new_windowed_resolution: Vector2i) -> void:
	DisplayServer.window_set_size(new_windowed_resolution)
	windowed_resolution = [new_windowed_resolution.x, new_windowed_resolution.y]


func set_screen_shake(enabled: bool) -> void:
	screen_shake = enabled


func saved_folder_exists() -> bool:
	var user_path = "user://"
	var saved_subpath = "saved"
	var dir = DirAccess.open(user_path)
	if !dir.dir_exists(saved_subpath):
		if dir.make_dir(saved_subpath) == OK:
			Logger.log_info({"message": "Succesfully created User Saved folder at: " + user_path + saved_subpath})
		else:
			Logger.log_error({"message": "Failed to create User Saved folder at: " + user_path + saved_subpath})
			return false
	return true


func save_user_settings() -> void:
	var config = ConfigFile.new()
	if !WINDOW_MODE_LABELS.has(DisplayServer.window_get_mode()):
		window_mode = DisplayServer.WINDOW_MODE_MAXIMIZED
	config.set_value("Display", "window_mode", DisplayServer.window_get_mode())
	config.set_value("Display", "windowed_resolution", [DisplayServer.window_get_size().x, DisplayServer.window_get_size().y])
	config.set_value("Gameplay", "screen_shake", screen_shake)

	var bus_index = AudioServer.get_bus_index("Master")
	config.set_value("Volume", "Master", db_to_linear(AudioServer.get_bus_volume_db(bus_index)))
	bus_index = AudioServer.get_bus_index("Music")
	config.set_value("Volume", "Music", db_to_linear(AudioServer.get_bus_volume_db(bus_index)))
	bus_index = AudioServer.get_bus_index("SFX")
	config.set_value("Volume", "SFX", db_to_linear(AudioServer.get_bus_volume_db(bus_index)))

	for control_mapping in control_mappings.keys():
		config.set_value("Controls", control_mapping, control_mappings[control_mapping])

	if saved_folder_exists():
		var err = config.save(Config.USER_SETTINGS_FILE_PATH)
		if err != OK:
			Logger.log_error({"message": "Failed to save config with error code: " + str(err)})


func load_user_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load(Config.USER_SETTINGS_FILE_PATH)
	if err != OK:
		return

	set_window_mode(config.get_value("Display", "window_mode", DisplayServer.WINDOW_MODE_MAXIMIZED))
	windowed_resolution = config.get_value("Display", "windowed_resolution", [1920, 1080])
	if windowed_resolution.size() != 2:
		windowed_resolution = [1920, 1080]
	set_windowed_resolution(Vector2i(windowed_resolution[0], windowed_resolution[1]))
	screen_shake = config.get_value("Gameplay", "screen_shake", true)

	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(config.get_value("Volume", "Master", 1.0)))
	bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(config.get_value("Volume", "Music", 1.0)))
	bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(config.get_value("Volume", "SFX", 1.0)))

	if config.has_section("Controls"):
		for control in config.get_section_keys("Controls"):
			control_mappings[control] = config.get_value("Controls", control)
