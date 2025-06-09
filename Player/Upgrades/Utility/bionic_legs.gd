extends Upgrade

var palettes_cleared: float = 0.0
var number_of_5_palettes_cleared: int = 0


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.BIONIC_LEGS
	name = "Bionic Legs"
	description = "For every 5 palettes cleared, gain 10% move speed up to 30%"


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(number_of_5_palettes_cleared)


func on_palette_cleared(palette: Palette) -> void:
	palettes_cleared += 1.0
	number_of_5_palettes_cleared = floori(palettes_cleared / 5.0)
	if number_of_5_palettes_cleared <= 3:
		Globals.player.move_speed = Globals.player.BASE_MOVE_SPEED * (1.0 + number_of_5_palettes_cleared / 10.0)
	upgrade_counter_updated.emit(number_of_5_palettes_cleared)


func on_upgrade_removed(removed_upgrade: Upgrade) -> void:
	if removed_upgrade == self:
		Globals.player.move_speed = Globals.player.BASE_MOVE_SPEED
