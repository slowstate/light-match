extends Upgrade

@warning_ignore("enum_variable_without_default")
var effect_timer: Timer
var speed_amount: float = 0.2
var effect_duration: float = 5.0


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.ADRENALINE_INJECTION
	name = "Adrenaline Injection"
	description = "After clearing 1 Palette, you gain " + str(speed_amount * 100) + "% speed for " + str(effect_duration + Save.lifetime_palettes * 0.05) + "s"
	icon = preload("res://Player/Upgrades/Utility/Adrenaline Injection.png")
	points_cost = 0
	effect_timer = super.new_timer()
	effect_timer.connect("timeout", _on_effect_timer_timeout)


func on_palette_cleared(_palette: Palette) -> void:
	if effect_timer.is_stopped():
		Globals.player.move_speed *= (1 + speed_amount)
		effect_timer.start(effect_duration + Save.lifetime_palettes * 0.05)
		is_active = true
	else:
		effect_timer.set_wait_time(effect_duration + Save.lifetime_palettes * 0.05)


func _on_effect_timer_timeout() -> void:
	Globals.player.move_speed /= (1 + speed_amount)
	is_active = false


func on_upgrade_removed(removed_upgrade: Upgrade) -> void:
	if removed_upgrade == self and !effect_timer.is_stopped():
		Globals.player.move_speed /= (1 + speed_amount)
