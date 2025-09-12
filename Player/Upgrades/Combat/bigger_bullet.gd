extends Upgrade


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.BIGGER_BULLET
	name = "Bigger Bullet"
	description = "After clearing 1 palette, your next bullet does 100% bonus damage"
	icon = preload("res://Player/Upgrades/Combat/Bigger Bullet.png")
	points_cost = 1


func on_palette_cleared(_palette: Palette) -> void:
	is_active = true


func on_enemy_hit(bullet: Bullet, _enemy: Enemy = null) -> void:
	if is_active:
		bullet.damage *= 2
		is_active = false
