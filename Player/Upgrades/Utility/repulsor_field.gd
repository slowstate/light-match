extends Upgrade


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.REPULSOR_FIELD
	name = "Repulsor Field"
	description = "After clearing a palette, knock back all nearby enemies"
	icon = preload("res://Player/Upgrades/Utility/Repulsor Field.png")


func on_upgrade_added(new_upgrade: Upgrade) -> void:
	if new_upgrade == self:
		is_active = true


func on_palette_cleared(_palette: Palette) -> void:
	var all_enemies_alive = Globals.get_all_enemies_alive()
	for enemy in all_enemies_alive:
		if (enemy.global_position - Globals.player.global_position).length() < 400.0:
			enemy.knock_back(400.0, 1.5)
