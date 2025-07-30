extends Upgrade

const STUN_EFFECT = preload("res://Common/StatusEffects/StunEffect/stun_effect.tscn")

@warning_ignore("enum_variable_without_default")
var last_killed_colour: Globals.Colour = Globals.Colour.BLUE
var number_of_same_colour_kills_in_a_row: int = 0
var effect_duration: float = 5.0


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.ENERGY_COLLECTOR
	name = "Energy Collector"
	description = "Killing 5 enemies of the same colour in a row grants you 1 shield. When your shield breaks, freeze all enemies for 5s"
	icon = preload("res://Player/Upgrades/Utility/Energy Collector.png")
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
	var frozen_enemies = Globals.get_all_enemies_alive()
	for enemy in frozen_enemies:
		var stun_effect = STUN_EFFECT.instantiate()
		stun_effect.effect_duration = effect_duration
		enemy.add_child(stun_effect)
	is_active = false
