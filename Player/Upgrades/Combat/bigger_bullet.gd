extends Upgrade

var is_active: bool
var trigger_timer: Timer


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.BIGGER_BULLET
	name = "Bigger Bullet"
	description = "After clearing a palette in 10s, your next bullet deals massive damage"
	trigger_timer = super.new_timer()


func on_palette_generated() -> void:
	trigger_timer.start(10)


func on_palette_cleared(palette: Palette) -> void:
	if !trigger_timer.is_stopped():
		is_active = true


func on_bullet_fired(bullet: Bullet) -> void:
	if is_active:
		bullet.damage = 99
	is_active = false
