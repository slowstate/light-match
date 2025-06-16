extends Upgrade


func _init() -> void:
	type = UpgradeManager.UpgradeTypes._3D_PRINTER
	name = "3D Printer"
	description = "Upgrades you own can appear during Upgrade selection"
	icon = preload("res://Player/Upgrades/Meta/3D Printer.png")


func on_upgrade_added(new_upgrade: Upgrade) -> void:
	if new_upgrade == self:
		is_active = true


func on_get_pickable_upgrades(pickable_upgrades: Array[UpgradeManager.UpgradeTypes]) -> void:
	for upgrade in UpgradeManager.get_player_upgrades():
		if !pickable_upgrades.has(upgrade.type):
			pickable_upgrades.push_back(upgrade.type)
