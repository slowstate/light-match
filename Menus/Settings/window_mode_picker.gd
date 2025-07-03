extends HBoxContainer

@onready var window_mode_label: Label = $WindowModeLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_window_mode_label_text()


func _update_window_mode_label_text() -> void:
	window_mode_label.text = Settings.WINDOW_MODE_LABELS[Settings.window_mode]


func _on_left_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	var window_mode_options := Settings.WINDOW_MODE_LABELS.keys()
	var current_window_mode := Settings.WINDOW_MODE_LABELS.keys().find(Settings.window_mode)
	if current_window_mode <= 0:
		current_window_mode = Settings.WINDOW_MODE_LABELS.keys().size() - 1
	else:
		current_window_mode -= 1
	Settings.set_window_mode(window_mode_options[current_window_mode])
	_update_window_mode_label_text()


func _on_right_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	var window_mode_options := Settings.WINDOW_MODE_LABELS.keys()
	var current_window_mode := Settings.WINDOW_MODE_LABELS.keys().find(Settings.window_mode)
	if current_window_mode >= Settings.WINDOW_MODE_LABELS.keys().size() - 1:
		current_window_mode = 0
	else:
		current_window_mode += 1
	Settings.set_window_mode(window_mode_options[current_window_mode])
	_update_window_mode_label_text()
