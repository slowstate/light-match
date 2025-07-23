extends Upgrade

@warning_ignore("enum_variable_without_default")
var enemy_killed_colour: Globals.Colour


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.SPRAY_PAINT
	name = "Spray Paint"
	description = "After killing an enemy, the next enemy to spawn will be the same colour"
	icon = preload("res://Player/Upgrades/Meta/Spray Paint.png")
	points_cost = 1


func on_upgrade_added(new_upgrade: Upgrade) -> void:
	if new_upgrade == self:
		is_active = true


func on_enemy_killed(enemy: Enemy) -> void:
	enemy_killed_colour = enemy.colour


func on_enemy_spawned(enemy: Enemy) -> void:
	if enemy_killed_colour != 0:
		enemy.set_colour(enemy_killed_colour)
