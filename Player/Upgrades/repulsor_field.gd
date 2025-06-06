extends Upgrade


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.REPULSOR_FIELD
	name = "Repulsor Field"
	description = "After clearing a palette, knock back all enemies within [400] pixels around you"


func on_palette_cleared() -> void:
	var all_enemies_alive: Array[Enemy] = Globals.get_all_enemies_alive()
	for enemy in all_enemies_alive:
		if (enemy.global_position - Globals.player.global_position).length() < 400:
			enemy.global_position
