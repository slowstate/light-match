extends Upgrade

var palettes_cleared: float = 0.0


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.BIONIC_LEGS
	name = "Bionic Legs"
	description = "For every 5 palettes cleared, gain 10% move speed up to 30%"


func on_palette_cleared() -> void:
	palettes_cleared += 1.0
	var number_of_5_palettes_cleared: float = floorf(palettes_cleared / 5.0)
	if number_of_5_palettes_cleared <= 3:
		Globals.player.move_speed = Globals.player.BASE_MOVE_SPEED * (1.0 + number_of_5_palettes_cleared / 10.0)
	print(str(Globals.player.move_speed))


func on_upgrade_removed(removed_upgrade: Upgrade) -> void:
	if removed_upgrade == self:
		Globals.player.move_speed = Globals.player.BASE_MOVE_SPEED
