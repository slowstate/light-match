extends Upgrade


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.PAINTBALL_GUN
	name = "Paintball Gun"
	description = "Enemies hit by a different colour have a chance to change to that colour"
	icon = preload("res://Player/Upgrades/Meta/Paintball Gun.png")


func on_upgrade_added(new_upgrade: Upgrade) -> void:
	if new_upgrade == self:
		is_active = true


func on_enemy_hit(bullet: Bullet, enemy: Enemy = null) -> void:
	if bullet.colour != enemy.colour:
		if randi() % 5 == 0:
			enemy.set_colour(bullet.colour)
			bullet.damage = 0
			UpgradeManager.on_enemy_colour_changed()


func on_enemy_appendage_hit(bullet: Bullet, appendage: Appendage):
	if bullet.colour != appendage.colour:
		if randi() % 2 == 0:
			appendage.set_colour(bullet.colour)
			bullet.damage = 0
