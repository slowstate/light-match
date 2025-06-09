extends Upgrade

var effect_timer: Timer
var frozen_enemies: Array[Enemy]
var palettes_cleared_in_a_row: int = 0


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.FREEZE_BOMB
	name = "Freeze Bomb"
	description = "After clearing 7 palettes in a row, freeze all enemies for 7s"
	effect_timer = super.new_timer()
	effect_timer.connect("timeout", _on_effect_timer_timeout)


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_palette_cleared(palette: Palette) -> void:
	palettes_cleared_in_a_row += 1
	if palettes_cleared_in_a_row >= 7:
		frozen_enemies = Globals.get_all_enemies_alive()
		for enemy in frozen_enemies:
			enemy.can_move = false
		effect_timer.start(7)
		palettes_cleared_in_a_row = 0
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_palette_failed() -> void:
	palettes_cleared_in_a_row = 0
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func _on_effect_timer_timeout() -> void:
	for enemy in frozen_enemies:
		if enemy != null:
			enemy.can_move = true


func on_upgrade_removed(removed_upgrade: Upgrade) -> void:
	if removed_upgrade == self and !effect_timer.is_stopped():
		for enemy in frozen_enemies:
			if enemy != null:
				enemy.can_move = true
