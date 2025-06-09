extends Upgrade

var triggered: bool = false


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.LUCKY_DICE
	name = "Lucky Dice"
	description = "Increase palette size by 1. Clearing a palette has a 50% chance to count twice"


func on_upgrade_added(new_upgrade: Upgrade) -> void:
	if new_upgrade == self:
		Globals.player.palette.palette_size += 1


func on_palette_cleared(palette: Palette) -> void:
	if triggered:
		triggered = false
	else:
		triggered = true
		if randi() % 2 == 0:
			UpgradeManager.on_palette_cleared(palette)
