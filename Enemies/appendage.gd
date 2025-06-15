class_name Appendage
extends Area2D

@export var sprite: Sprite2D
var colour: Globals.Colour = Globals.Colour.BLUE


func set_colour(new_colour: Globals.Colour) -> void:
	colour = new_colour
	sprite.modulate = Globals.COLOUR_VISUAL_VALUE[new_colour]


func _on_area_entered(area: Area2D) -> void:
	var bullet = area as Bullet
	if bullet == null:
		return

	UpgradeManager.on_enemy_appendage_hit(bullet, self)
	if bullet.colour != colour:
		return
	if bullet.damage > 0:
		queue_free()
