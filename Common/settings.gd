extends Node

const WINDOW_MODE_LABELS = {DisplayServer.WINDOW_MODE_FULLSCREEN: "Fullscreen", DisplayServer.WINDOW_MODE_WINDOWED: "Windowed"}

var window_mode := DisplayServer.WINDOW_MODE_WINDOWED
var windowed_resolution: Vector2i
var master_volume


func set_window_mode(new_window_mode: int) -> void:
	window_mode = new_window_mode
	DisplayServer.window_set_mode(window_mode)


func set_windowed_resolution(new_windowed_resolution: Vector2i) -> void:
	windowed_resolution = new_windowed_resolution
	DisplayServer.window_set_size(windowed_resolution)


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

	config.set_value("Display", "window_mode", window_mode)
	config.set_value("Display", "windowed_resolution", DisplayServer.window_get_size())

	var bus_index = AudioServer.get_bus_index("Master")
	config.set_value("Volume", "Master", db_to_linear(AudioServer.get_bus_volume_db(bus_index)))
	bus_index = AudioServer.get_bus_index("Music")
	config.set_value("Volume", "Music", db_to_linear(AudioServer.get_bus_volume_db(bus_index)))
	bus_index = AudioServer.get_bus_index("SFX")
	config.set_value("Volume", "SFX", db_to_linear(AudioServer.get_bus_volume_db(bus_index)))

	if saved_folder_exists():
		var err = config.save(Config.USER_SETTINGS_FILE_PATH)
		if err != OK:
			Logger.log_error({"message": "Failed to save config with error code: " + str(err)})


func load_user_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load(Config.USER_SETTINGS_FILE_PATH)
	if err != OK:
		return

	set_window_mode(config.get_value("Display", "window_mode", DisplayServer.WINDOW_MODE_WINDOWED))
	set_windowed_resolution(config.get_value("Display", "windowed_resolution", Vector2i(1920, 1080)))

	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(config.get_value("Volume", "Master", 1.0)))
	bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(config.get_value("Volume", "Music", 1.0)))
	bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(config.get_value("Volume", "SFX", 1.0)))
