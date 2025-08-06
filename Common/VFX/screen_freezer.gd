extends Node


func freeze(duration: float = 0.05) -> void:
	get_tree().paused = true
	await get_tree().create_timer(duration).timeout
	get_tree().paused = false
