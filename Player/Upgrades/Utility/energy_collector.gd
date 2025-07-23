extends Upgrade

@warning_ignore("enum_variable_without_default")
var last_killed_colour: Globals.Colour
var number_of_same_colour_kills_in_a_row: int = 0
var frozen_enemies: Array[Enemy]
var effect_time: float = 5.0
var effect_timer: Timer


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.ENERGY_COLLECTOR
	name = "Energy Collector"
	description = "Killing 5 enemies of the same colour in a row grants you 1 shield. When your shield breaks, freeze all enemies for 5s"
	icon = preload("res://Player/Upgrades/Utility/Energy Collector.png")
	effect_timer = super.new_timer()
	points_cost = 3


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(number_of_same_colour_kills_in_a_row)


func on_enemy_killed(enemy: Enemy) -> void:
	if enemy.colour != last_killed_colour:
		number_of_same_colour_kills_in_a_row = 0
	last_killed_colour = enemy.colour
	number_of_same_colour_kills_in_a_row += 1
	if number_of_same_colour_kills_in_a_row >= 5:
		Globals.player.shield_active = true
		is_active = true
		number_of_same_colour_kills_in_a_row = 0
	upgrade_counter_updated.emit(number_of_same_colour_kills_in_a_row)


func on_player_shield_break() -> void:
	frozen_enemies = Globals.get_all_enemies_alive()
	for enemy in frozen_enemies:
		enemy.stun(effect_time)
		enemy.linear_velocity = Vector2(0, 0)
	is_active = false
