extends Upgrade

var trigger_timer: Timer


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.BIGGER_BULLET
	name = "Bigger Bullet"
	description = "After clearing a palette within 10s, your next bullet does massive damage to any colour"
	icon = preload("res://Player/Upgrades/Combat/Bigger Bullet.png")
	trigger_timer = super.new_timer()


func on_palette_generated() -> void:
	trigger_timer.start(10)


func on_palette_cleared(_palette: Palette) -> void:
	if !trigger_timer.is_stopped():
		is_active = true


func on_enemy_hit(bullet: Bullet, enemy: Enemy = null) -> void:
	if is_active:
		bullet.colour = enemy.colour
		bullet.damage = 99
		is_active = false
