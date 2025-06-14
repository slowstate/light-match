extends Area2D


func _on_area_entered(area: Area2D) -> void:
	var enemy = owner as Enemy
	enemy._on_area_entered(area)
