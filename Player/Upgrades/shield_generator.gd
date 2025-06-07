extends Upgrade

var palettes_cleared_in_a_row: int


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.SHIELD_GENERATOR
	name = "Shield Generator"
	description = "After clearing 3 palettes in a row, gain 1 shield "


func on_palette_cleared() -> void:
	palettes_cleared_in_a_row += 1
	if palettes_cleared_in_a_row >= 3:
		Globals.player.shield = true
		palettes_cleared_in_a_row = 0


func on_palette_failed() -> void:
	palettes_cleared_in_a_row = 0
