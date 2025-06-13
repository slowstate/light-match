extends Node2D

const ARENA = preload("res://Arena/arena.tscn")
@onready var music_manager: Node2D = $MusicManager

func _ready() -> void:
	music_manager.update_music(0.0)

func _on_start_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX",-15.0,-13.0,0.9,1.1)
	get_tree().change_scene_to_packed(ARENA)


func _on_exit_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX",-15.0,-13.0,0.9,1.1)
	get_tree().quit()
