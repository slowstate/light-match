extends Upgrade


func _init() -> void:
	type = UpgradeManager.UpgradeTypes._3D_PRINTER
	name = "3D PRINTER"
	description = "Upgrades you own can appear during Upgrade selection"


func on_get_pickable_upgrades(pickable_upgrades: Array[UpgradeManager.UpgradeTypes]) -> void:
	for upgrade in UpgradeManager.get_player_upgrades():
		if !pickable_upgrades.has(upgrade.type):
			pickable_upgrades.push_back(upgrade.type)
