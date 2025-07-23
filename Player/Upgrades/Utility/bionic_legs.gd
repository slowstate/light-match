extends Upgrade

var palettes_cleared: float = 0.0


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.BIONIC_LEGS
	name = "Bionic Legs"
	description = "For every 10 palettes cleared, you gain 5% move speed up to a maximum of 20%"
	icon = preload("res://Player/Upgrades/Utility/Bionic Leg.png")
	points_cost = 3


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(palettes_cleared)


func on_palette_cleared(_palette: Palette) -> void:
	if palettes_cleared < 20:
		palettes_cleared += 1.0
		upgrade_counter_updated.emit(palettes_cleared)
	var number_of_5_palettes_cleared = floori(palettes_cleared / 5.0)
	if number_of_5_palettes_cleared > 0 and number_of_5_palettes_cleared <= 6:
		Globals.player.move_speed = Globals.player.base_move_speed * (1.0 + number_of_5_palettes_cleared * 0.1)
		is_active = true


func on_upgrade_removed(removed_upgrade: Upgrade) -> void:
	if removed_upgrade == self:
		Globals.player.move_speed = Globals.player.base_move_speed
