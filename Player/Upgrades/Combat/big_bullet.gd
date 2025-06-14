extends Upgrade

var effect_timer: Timer


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.BIG_BULLET
	name = "Big Bullet"
	description = "After clearing a palette, your bullets deal double damage for 5s"
	icon = preload("res://Player/Upgrades/Combat/Big Bullet.png")
	effect_timer = super.new_timer()
	effect_timer.connect("timeout", _on_effect_timer_timeout)


func on_palette_cleared(_palette: Palette) -> void:
	effect_timer.start(5)
	SignalBus.upgrade_activated.emit(self)


func on_bullet_fired(bullet: Bullet) -> void:
	if !effect_timer.is_stopped():
		bullet.damage *= 2


func _on_effect_timer_timeout() -> void:
	SignalBus.upgrade_deactivated.emit(self)
