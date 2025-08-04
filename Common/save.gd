extends Node

var lifetime_palettes: int = 0


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


func save_user_save() -> void:
	if FileAccess.file_exists(Config.USER_SAVE_FILE_PATH):
		if FileAccess.file_exists(Config.USER_BACKUP_SAVE_FILE_PATH):
			OS.move_to_trash(ProjectSettings.globalize_path(Config.USER_BACKUP_SAVE_FILE_PATH))
		DirAccess.rename_absolute(ProjectSettings.globalize_path(Config.USER_SAVE_FILE_PATH), ProjectSettings.globalize_path(Config.USER_BACKUP_SAVE_FILE_PATH))
	var save_file = FileAccess.open(Config.USER_SAVE_FILE_PATH, FileAccess.WRITE)
	var save_data = {"lifetime_palettes": lifetime_palettes}
	save_file.store_var(save_data)
	save_file.close()
	Logger.log_info({"message": "User save saved"})


func load_user_save() -> void:
	if not FileAccess.file_exists(Config.USER_SAVE_FILE_PATH):
		Logger.log_info({"message": "No user save to load"})
		return
	var save_file = FileAccess.open(Config.USER_SAVE_FILE_PATH, FileAccess.READ)
	var save_data = save_file.get_var() as Dictionary
	lifetime_palettes = save_data.get("lifetime_palettes")
	save_file.close()
	Logger.log_info({"message": "User save loaded"})
