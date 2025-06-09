extends Upgrade

var last_killed_colour: Globals.Colour
var number_of_same_colour_kills_in_a_row: int = 0


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.ENERGY_COLLECTOR
	name = "Energy Collector"
	description = "Killing 5 enemies of the same colour in a row grants you 1 shield"


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(number_of_same_colour_kills_in_a_row)


func on_enemy_killed(enemy: Enemy) -> void:
	if enemy.colour != last_killed_colour:
		number_of_same_colour_kills_in_a_row = 0
	last_killed_colour = enemy.colour
	number_of_same_colour_kills_in_a_row += 1
	if number_of_same_colour_kills_in_a_row >= 5:
		Globals.player.shield = true
		number_of_same_colour_kills_in_a_row = 0
	upgrade_counter_updated.emit(number_of_same_colour_kills_in_a_row)
