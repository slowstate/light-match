extends CanvasLayer

var MAIN_MENU = load("res://Menus/MainMenu/main_menu.tscn")

@onready var settings: Control = $Settings


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("player_cancel"):
		visible = !visible
		get_tree().paused = visible
		SignalBus.paused.emit(visible)


func _on_settings_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)


func _on_settings_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	settings.visible = true


func _on_main_menu_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)


func _on_main_menu_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	get_tree().change_scene_to_packed(MAIN_MENU)


func _on_back_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)


func _on_back_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	visible = false
	get_tree().paused = false
	SignalBus.paused.emit(visible)
