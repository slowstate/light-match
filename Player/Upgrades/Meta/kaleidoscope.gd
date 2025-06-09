extends Upgrade


func _init() -> void:
	#type = UpgradeManager.UpgradeTypes.KALEIDOSCOPE
	name = "Kaleidoscope"
	description = "Decrease palette size by 1. Palettes can't have duplicate colours"


func on_upgrade_added(new_upgrade: Upgrade) -> void:
	if new_upgrade == self:
		Globals.player.palette.palette_size -= 1
		Globals.player.palette.palette_can_have_duplicates = false


func on_upgrade_removed(removed_upgrade: Upgrade) -> void:
	if removed_upgrade == self:
		Globals.player.palette.palette_size += 1
		Globals.player.palette.palette_can_have_duplicates = true
