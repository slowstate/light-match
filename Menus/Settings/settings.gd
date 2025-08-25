extends Control

@onready var controls: Control = $Controls
@onready var credits: Control = $Credits
@onready var reset_data_button: Button = $SettingsButtons/ResetDataButton
@onready var reset_data: Control = $ResetData


func _ready() -> void:
	visible = false
	if get_parent() is Arena:
		reset_data_button.disabled = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_cancel"):
		for control_remapper in get_tree().get_nodes_in_group("Control Remappers"):
			control_remapper = control_remapper as ControlRemapper
			if control_remapper.control_remap_button.button_pressed:
				return
		visible = false


func _on_settings_back_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)


func _on_settings_back_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	visible = false
	controls.visible = false
	credits.visible = false


func _on_check_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)


func _on_check_button_toggled(toggled_on: bool) -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	Settings.screen_shake = toggled_on


func _on_controls_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)


func _on_controls_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	controls.visible = true


func _on_controls_back_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)


func _on_controls_back_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	controls.visible = false


func _on_credits_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)


func _on_credits_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	credits.visible = true


func _on_credits_back_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)


func _on_credits_back_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	credits.visible = false


func _on_reset_data_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)


func _on_reset_data_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	reset_data.update_data()
	reset_data.visible = true


func _on_confirm_reset_data_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)


func _on_confirm_reset_data_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	Save.lifetime_palettes = 0
	reset_data.visible = false


func _on_cancel_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)


func _on_cancel_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	reset_data.visible = false
