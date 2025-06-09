extends Upgrade


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.REPULSOR_FIELD
	name = "Repulsor Field"
	description = "After clearing a palette, knock back all nearby enemies"


func on_palette_cleared(palette: Palette) -> void:
	var all_enemies_alive = Globals.get_all_enemies_alive()
	for enemy in all_enemies_alive:
		enemy.knock_back(Globals.player.global_position, 500.0)
