extends Upgrade

var effect_timer: Timer


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.BIG_BULLET
	name = "Big Bullet"
	description = "After clearing 1 palette, your bullets deal 1 bonus damage for 10s"
	icon = preload("res://Player/Upgrades/Combat/Big Bullet.png")
	effect_timer = super.new_timer()
	points_cost = 3
	effect_timer.connect("timeout", _on_effect_timer_timeout)


func on_palette_cleared(_palette: Palette) -> void:
	effect_timer.start(10)
	is_active = true


func on_bullet_fired(bullet: Bullet) -> void:
	if !effect_timer.is_stopped():
		bullet.damage += 2


func _on_effect_timer_timeout() -> void:
	is_active = false
