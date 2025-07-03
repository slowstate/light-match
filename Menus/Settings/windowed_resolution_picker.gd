extends HBoxContainer

@onready var windowed_resolution_label: Label = $WindowedResolutionLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_windowed_resolution_label_text()


func _update_windowed_resolution_label_text() -> void:
	windowed_resolution_label.text = str(Settings.windowed_mode_resolution.x) + " X " + str(Settings.windowed_mode_resolution.y)


func _on_left_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	var windowed_resolution_options = Settings.get_window_mode_windowed_options()
	var current_windowed_resolution = windowed_resolution_options.find(Settings.windowed_mode_resolution)
	if current_windowed_resolution <= 0:
		current_windowed_resolution = windowed_resolution_options.size() - 1
	else:
		current_windowed_resolution -= 1
	Settings.set_windowed_resolution(windowed_resolution_options[current_windowed_resolution])
	_update_windowed_resolution_label_text()


func _on_right_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	var windowed_resolution_options = Settings.get_window_mode_windowed_options()
	var current_windowed_resolution = windowed_resolution_options.find(Settings.windowed_mode_resolution)
	if current_windowed_resolution >= windowed_resolution_options.size() - 1:
		current_windowed_resolution = 0
	else:
		current_windowed_resolution += 1
	Settings.set_windowed_resolution(windowed_resolution_options[current_windowed_resolution])
	_update_windowed_resolution_label_text()
