class_name Condition
extends Resource

var name: String
var description: String
var points_per_round: int = 1


#region
func on_condition_added(_condition: Condition) -> void:
	pass


func on_round_loaded(_round: Round) -> void:
	pass


func on_enemy_spawned(_enemy: Enemy) -> void:
	pass


func on_enemy_slowed(_enemy: Enemy) -> void:
	pass


func on_enemy_stunned(_enemy: Enemy) -> void:
	pass


func on_enemy_hit(_bullet: Bullet, _enemy: Enemy) -> void:
	pass
#endregion
