extends Node


#region
func on_variable_added(new_variable: Variable) -> void:
	for variable in get_player_variables():
		variable.on_variable_added(new_variable)


func on_round_loaded(round: Round) -> void:
	for variable in get_player_variables():
		variable.on_round_loaded(round)


func on_enemy_spawned(enemy: Enemy) -> void:
	for variable in get_player_variables():
		variable.on_enemy_spawned(enemy)


#endregion


func get_player_variables() -> Array[Variable]:
	if Globals.player != null:
		return Globals.player.variables
	return []
