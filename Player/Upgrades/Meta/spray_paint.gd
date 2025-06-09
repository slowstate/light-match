extends Upgrade

var is_active: bool = false
var enemy_killed_colour: Globals.Colour


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.SPRAY_PAINT
	name = "Spray Paint"
	description = "After killing an enemy, the next enemy to spawn has a 50% chance of being the same colour"


func on_enemy_killed(enemy: Enemy) -> void:
	enemy_killed_colour = enemy.colour
	is_active = true


func on_enemy_spawned(enemy: Enemy) -> void:
	if is_active:
		if randi() % 2 == 0:
			enemy.set_colour(enemy_killed_colour)
	is_active = false
