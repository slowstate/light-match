extends Node2D

const ARENA = preload("res://Arena/arena.tscn")


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(ARENA)


func _on_exit_button_pressed() -> void:
	get_tree().quit()
