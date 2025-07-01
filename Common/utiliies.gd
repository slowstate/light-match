extends Node

var application_started_date_time


func _notification(what):
	if what == NOTIFICATION_READY:
		application_started_date_time = Time.get_unix_time_from_system()
		var log_play_data = {"message": "Application started"}
		Logger.log_play_data(log_play_data)
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		var application_elapsed_time = Time.get_unix_time_from_system() - application_started_date_time
		var log_context_data = {"application_elapsed_time": Time.get_time_string_from_unix_time(application_elapsed_time)}
		var log_play_data = {"message": "Application exited", "context": log_context_data}
		Logger.log_play_data(log_play_data)
