extends Upgrade

const MOVE_SPEED_EFFECT = preload("res://Common/StatusEffects/MoveSpeedEffect/move_speed_effect.tscn")

var palettes_cleared_in_a_row: int = 0
var slow_amount: float = 0.9
var effect_duration: float = 10.0


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.SHIELD_GENERATOR
	name = "Shield Generator"
	description = (
		"After clearing 3 palettes in a row, gain 1 shield. When your shield breaks, slows all nearby enemies by "
		+ str(slow_amount * 100)
		+ "% for "
		+ str(effect_duration)
		+ "s"
	)
	icon = preload("res://Player/Upgrades/Utility/Shield Generator.png")
	points_cost = 1


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_palette_cleared(_palette: Palette) -> void:
	palettes_cleared_in_a_row += 1
	if palettes_cleared_in_a_row >= 3:
		Globals.player.shield_active = true
		is_active = true
		palettes_cleared_in_a_row = 0
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_palette_failed() -> void:
	palettes_cleared_in_a_row = 0
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_player_shield_break() -> void:
	var all_enemies_alive = Globals.get_all_enemies_alive()
	for enemy in all_enemies_alive:
		if enemy.player_is_within_distance(500.0):
			var move_speed_effect = MOVE_SPEED_EFFECT.instantiate()
			move_speed_effect.effect_amount = -slow_amount
			move_speed_effect.effect_duration = effect_duration
			enemy.add_child(move_speed_effect)
	is_active = false
