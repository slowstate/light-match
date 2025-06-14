extends Upgrade


func _init() -> void:
	type = UpgradeManager.UpgradeTypes._4D_GLASSES
	name = "4D-Glasses"
	description = "Increase palette size by 1. Palettes cannot be failed"
	icon = preload("res://Player/Upgrades/Meta/4D Glasses.png")


func on_upgrade_added(new_upgrade: Upgrade) -> void:
	if new_upgrade == self:
		Globals.player.palette.palette_size += 1
		Globals.player.palette.palette_can_fail = false
		SignalBus.upgrade_activated.emit(self)


func on_upgrade_removed(removed_upgrade: Upgrade) -> void:
	if removed_upgrade == self:
		Globals.player.palette.palette_size -= 1
		Globals.player.palette.palette_can_fail = true
