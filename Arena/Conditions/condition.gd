class_name Condition
extends Resource

var name: String
var description: String
var points_per_round: int = 1


#region
func on_condition_added(condition: Condition) -> void:
	pass


func on_round_loaded(round: Round) -> void:
	pass


func on_enemy_spawned(enemy: Enemy) -> void:
	pass


func on_enemy_hit(bullet: Bullet, enemy: Enemy) -> void:
	pass
#endregion
