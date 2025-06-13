extends Upgrade


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.PAINTBALL_GUN
	name = "Paintball Gun"
	description = "Enemies hit by a different colour have a 20% chance to change to that colour"
	icon = preload("res://Player/Upgrades/Meta/Paintball Gun.png")


func on_enemy_hit(bullet: Bullet, enemy: Enemy = null) -> void:
	if bullet.colour != enemy.colour:
		if randi() % 5 == 0:
			enemy.set_colour(bullet.colour)
			bullet.damage = 0
