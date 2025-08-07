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
		SfxManager.play_sound("EnemyDeflectSFX", -5.0, -3.0, 0.95, 1.05)
		return
	SfxManager.play_sound("EnemyHitSFX", -25.0, -23.0, 2.0, 2.2)
	if bullet.damage > 0:
		queue_free()


func dim_lights(dim_amount: float) -> void:
	sprite.self_modulate.a = 1.0 - dim_amount
