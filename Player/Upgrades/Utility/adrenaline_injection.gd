extends Upgrade

@warning_ignore("enum_variable_without_default")
var effect_timer: Timer
var speed_amount: float = 0.2
var effect_duration: float = 6.0


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.ADRENALINE_INJECTION
	name = "Adrenaline Injection"
	description = "After completing a Sequence, you temporarily move faster"
	added_dialogue = "Another adaptation! This should improve your agility"
	icon = preload("res://Player/Upgrades/Utility/Adrenaline Injection.png")
	points_cost = 0
	effect_timer = super.new_timer()
	effect_timer.connect("timeout", _on_effect_timer_timeout)


func on_palette_cleared(_palette: Palette) -> void:
	if effect_timer.is_stopped():
		Globals.player.move_speed *= clamp(1 + speed_amount + Save.lifetime_palettes * 0.05, 1, 1.4)
	Globals.player.enable_after_image(true)
	effect_timer.start(effect_duration)
	is_active = true
	SfxManager.play_sound("AdrenalineInjectionActiveSFX", -15.0, -13.0, 0.7, 0.8)

func _on_effect_timer_timeout() -> void:
	Globals.player.move_speed /= clamp(1 + speed_amount + Save.lifetime_palettes * 0.05, 1, 1.4)
	Globals.player.enable_after_image(false)
	is_active = false


func on_upgrade_removed(removed_upgrade: Upgrade) -> void:
	if removed_upgrade == self and !effect_timer.is_stopped():
		Globals.player.move_speed /= clamp(1 + speed_amount + Save.lifetime_palettes * 0.05, 1, 1.4)
		Globals.player.enable_after_image(false)
