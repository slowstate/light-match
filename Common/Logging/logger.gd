extends Node


func log_info(log_data: Dictionary) -> void:
	var log = {}
	if !log_data.has("timestamp"):
		log.merge({"timestamp": Time.get_datetime_string_from_system()}, true)
	if !log_data.has("level"):
		log.merge({"level": "INFO"}, true)
	if !log_data.has("current_scene"):
		log.merge({"current_scene": get_tree().current_scene.name if get_tree().current_scene != null else "None"}, true)
	log.merge(log_data, true)
	var json_string = JSON.stringify(log, "", false)
	print(json_string)


func log_error(log_data: Dictionary) -> void:
	var log = {}
	if !log_data.has("timestamp"):
		log.merge({"timestamp": Time.get_datetime_string_from_system()}, true)
	if !log_data.has("level"):
		log.merge({"level": "ERROR"}, true)
	if !log_data.has("current_scene"):
		log.merge({"current_scene": get_tree().current_scene.name if get_tree().current_scene != null else "None"}, true)
	log.merge(log_data, true)
	var json_string = JSON.stringify(log, "", false)
	printerr(json_string)


func log_play_data(log_data: Dictionary) -> void:
	if !Config.ENABLE_PLAY_DATA_LOGS:
		return
	var log = {}
	if !log_data.has("timestamp"):
		log.merge({"timestamp": Time.get_datetime_string_from_system()}, true)
	if !log_data.has("level"):
		log.merge({"level": "PLAY_DATA"}, true)
	if !log_data.has("current_scene"):
		log.merge({"current_scene": get_tree().current_scene.name if get_tree().current_scene != null else "None"}, true)
	log.merge(log_data, true)
	var json_string = JSON.stringify(log, "", false)
	print(json_string)


func log_debug(log_data: Dictionary) -> void:
	if !OS.is_debug_build():
		return
	var log = {}
	if !log_data.has("timestamp"):
		log.merge({"timestamp": Time.get_datetime_string_from_system()}, true)
	if !log_data.has("level"):
		log.merge({"level": "DEBUG"}, true)
	if !log_data.has("current_scene"):
		log.merge({"current_scene": get_tree().current_scene.name if get_tree().current_scene != null else "None"}, true)
	log.merge(log_data, true)
	var json_string = JSON.stringify(log, "", false)
	print_debug(json_string)
