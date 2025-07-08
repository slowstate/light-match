extends Node

const Slow = preload("res://Arena/Conditions/slow.gd")
const Supercharged = preload("res://Arena/Conditions/supercharged.gd")
const Swarm = preload("res://Arena/Conditions/swarm.gd")

var ALL_CONDITIONS = [Slow, Supercharged, Swarm]


#region
func on_condition_added(new_condition: Condition) -> void:
	for condition in get_player_conditions():
		condition.on_condition_added(new_condition)


func on_round_loaded(round: Round) -> void:
	for condition in get_player_conditions():
		condition.on_round_loaded(round)


func on_enemy_spawned(enemy: Enemy) -> void:
	for condition in get_player_conditions():
		condition.on_enemy_spawned(enemy)


#endregion


func get_player_conditions() -> Array[Condition]:
	if Globals.player != null:
		return Globals.player.conditions
	return []
