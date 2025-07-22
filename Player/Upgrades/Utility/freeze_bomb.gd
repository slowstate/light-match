extends Upgrade

var effect_time: float = 15.0
var effect_timer: Timer
var frozen_enemies: Array[Enemy]
var palettes_cleared_in_a_row: int = 0


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.FREEZE_BOMB
	name = "Freeze Bomb"
	description = "After clearing 4 palettes in a row, freeze all enemies for 15s"
	icon = preload("res://Player/Upgrades/Utility/Freeze Bomb.png")
	effect_timer = super.new_timer()
	effect_timer.connect("timeout", _on_effect_timer_timeout)


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_palette_cleared(_palette: Palette) -> void:
	palettes_cleared_in_a_row += 1
	if palettes_cleared_in_a_row >= 4:
		frozen_enemies = Globals.get_all_enemies_alive()
		for enemy in frozen_enemies:
			enemy.stun(effect_time)
			enemy.linear_velocity = Vector2(0, 0)
			ConditionManager.on_enemy_stunned(enemy)
		effect_timer.start(effect_time)
		is_active = true
		palettes_cleared_in_a_row = 0

	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_palette_failed() -> void:
	palettes_cleared_in_a_row = 0
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func _on_effect_timer_timeout() -> void:
	is_active = false
