extends Upgrade

var palettes_cleared_in_a_row: int = 0


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.PAINT_BOMB
	name = "Paint Bomb"
	description = "After clearing 5 palettes in a row, change all enemies on the screen to the same colour"
	icon = preload("res://Player/Upgrades/Meta/Paint Bomb.png")


func on_upgrade_added(new_upgrade: Upgrade) -> void:
	if new_upgrade == self:
		SignalBus.upgrade_activated.emit(self)


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_palette_cleared(_palette: Palette) -> void:
	palettes_cleared_in_a_row += 1
	if palettes_cleared_in_a_row >= 5:
		var random_colour = Globals.Colour.values().pick_random()
		for enemy in Globals.get_all_enemies_alive():
			enemy.set_colour(random_colour)
		palettes_cleared_in_a_row = 0
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_palette_failed() -> void:
	palettes_cleared_in_a_row = 0
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)
