extends Upgrade

var palettes_cleared_in_a_row: int = 0


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.PAINT_BOMB
	name = "Paint Bomb"
	description = "After clearing 3 palettes in a row, change all enemies on the screen to the same colour"
	icon = preload("res://Player/Upgrades/Meta/Paint Bomb.png")
	points_cost = 3


func on_upgrade_added(new_upgrade: Upgrade) -> void:
	if new_upgrade == self:
		is_active = true


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_palette_cleared(_palette: Palette) -> void:
	palettes_cleared_in_a_row += 1
	if palettes_cleared_in_a_row >= 3:
		var random_colour = Globals.Colour.values().pick_random()
		for enemy in Globals.get_all_enemies_alive():
			enemy.set_colour(random_colour)
			UpgradeManager.on_enemy_colour_changed()
			for appendage in enemy.get_appendages():
				appendage.set_colour(random_colour)
		palettes_cleared_in_a_row = 0
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_palette_failed() -> void:
	palettes_cleared_in_a_row = 0
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)
