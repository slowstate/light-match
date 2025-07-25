extends Condition

const MOVE_SPEED_EFFECT = preload("res://Common/StatusEffects/MoveSpeedEffect/move_speed_effect.tscn")

var move_speed_increase: float = 0.3
var effect_duration: float = 5.0


func _init() -> void:
	name = "Rush"
	description = "Enemies are " + str(move_speed_increase * 100) + "% faster for " + str(effect_duration) + "s after they spawn "
	points_per_round = 2


func on_enemy_spawned(enemy: Enemy) -> void:
	var move_speed_effect = MOVE_SPEED_EFFECT.instantiate()
	move_speed_effect.effect_amount = move_speed_increase
	move_speed_effect.effect_duration = effect_duration
	enemy.add_child(move_speed_effect)
