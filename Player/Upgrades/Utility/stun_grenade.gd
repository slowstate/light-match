extends Upgrade

const STUN_EFFECT = preload("res://Common/StatusEffects/StunEffect/stun_effect.tscn")

var effect_duration: float = 5.0
var effect_timer: Timer
var palettes_cleared_counter: int = 0


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.STUN_GRENADE
	name = "Stun Grenade"
	description = "After clearing 2 Chains, stun all enemies for " + str(floor(effect_duration + Save.lifetime_palettes * 0.02)) + "s"
	icon = preload("res://Player/Upgrades/Utility/Stun Grenade.png")
	points_cost = 0
	effect_timer = super.new_timer()
	effect_timer.connect("timeout", _on_effect_timer_timeout)


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(palettes_cleared_counter)


func on_palette_cleared(_palette: Palette) -> void:
	palettes_cleared_counter += 1
	if palettes_cleared_counter >= 2:
		for enemy in Globals.get_all_enemies_alive():
			var stun_effect = STUN_EFFECT.instantiate()
			stun_effect.effect_duration = effect_duration
			enemy.add_child(stun_effect)
		effect_timer.start(effect_duration)
		is_active = true
		palettes_cleared_counter = 0

	upgrade_counter_updated.emit(palettes_cleared_counter)


func _on_effect_timer_timeout() -> void:
	is_active = false
