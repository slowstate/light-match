extends Upgrade

var effect_timer: Timer


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.POWER_DIVERTER
	name = "Power Diverter"
	description = "Changing gun colour increases your move speed by 30% for 0.5s"
	icon = preload("res://Player/Upgrades/Utility/Power Divertor.png")
	effect_timer = super.new_timer()
	effect_timer.connect("timeout", _on_effect_timer_timeout)


func on_gun_colour_switch(_gun_cooldown_timer: Timer) -> void:
	if effect_timer.is_stopped():
		Globals.player.move_speed *= 1.3
		effect_timer.start(0.5)
		SignalBus.upgrade_activated.emit(self)


func _on_effect_timer_timeout() -> void:
	Globals.player.move_speed /= 1.3
	SignalBus.upgrade_deactivated.emit(self)


func on_upgrade_removed(removed_upgrade: Upgrade) -> void:
	if removed_upgrade == self and !effect_timer.is_stopped():
		Globals.player.move_speed /= 1.3
