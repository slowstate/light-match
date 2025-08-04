extends Area2D

signal player_hit


func _ready() -> void:
	self.area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area.collision_layer == Globals.CollisionLayer.PLAYER:
		player_hit.emit()
		return
	var enemy = owner as Enemy
	enemy._on_area_entered(area)
