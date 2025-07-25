extends Upgrade

const STUN_EFFECT = preload("res://Common/StatusEffects/StunEffect/stun_effect.tscn")

var effect_duration: float = 10.0
var effect_timer: Timer
var palettes_cleared_in_a_row: int = 2


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.FREEZE_BOMB
	name = "Freeze Bomb"
	description = "After clearing 3 palettes in a row, stun all enemies for 10s"
	icon = preload("res://Player/Upgrades/Utility/Freeze Bomb.png")
	points_cost = 6
	effect_timer = super.new_timer()
	effect_timer.connect("timeout", _on_effect_timer_timeout)


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_palette_cleared(_palette: Palette) -> void:
	palettes_cleared_in_a_row += 1
	if palettes_cleared_in_a_row >= 3:
		for enemy in Globals.get_all_enemies_alive():
			var stun_effect = STUN_EFFECT.instantiate()
			stun_effect.effect_duration = effect_duration
			enemy.add_child(stun_effect)
		is_active = true
		palettes_cleared_in_a_row = 0

	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_palette_failed() -> void:
	palettes_cleared_in_a_row = 0
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func _on_effect_timer_timeout() -> void:
	is_active = false
