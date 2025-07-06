class_name Variable
extends Resource

var name: String
var description: String
var points_per_round: int


#region
func on_variable_added(variable: Variable) -> void:
	pass


func on_round_loaded(round: Round) -> void:
	pass


func on_enemy_spawned(enemy: Enemy) -> void:
	pass
#endregion
