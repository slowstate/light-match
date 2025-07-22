extends Area2D

signal player_hit


func _on_area_entered(area: Area2D) -> void:
	if area.collision_layer == Globals.CollisionLayer.PLAYER:
		player_hit.emit()
		return
	var enemy = owner as Enemy
	enemy._on_area_entered(area)
