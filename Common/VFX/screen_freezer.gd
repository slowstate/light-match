extends Node

var paused: bool = false


func _ready() -> void:
	if !SignalBus.paused.is_connected(_on_paused):
		SignalBus.paused.connect(_on_paused)


func freeze(duration: float = 0.02) -> void:
	get_tree().paused = true
	await get_tree().create_timer(duration).timeout
	if !paused:
		get_tree().paused = false


func _on_paused(is_paused: bool) -> void:
	paused = is_paused
