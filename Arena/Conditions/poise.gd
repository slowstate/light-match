extends Condition

var slow_and_stun_duration_reduction: float = 0.5


func _init() -> void:
	name = "Poise"
	description = "Reduces the duration of slows and stuns on enemies by " + str(slow_and_stun_duration_reduction * 100) + "%"
	points_per_round = 1


func on_enemy_pre_slowed(_enemy: Enemy, move_speed_effect: MoveSpeedEffect) -> void:
	move_speed_effect.effect_duration *= slow_and_stun_duration_reduction


func on_enemy_pre_stunned(_enemy: Enemy, stun_effect: StunEffect) -> void:
	stun_effect.effect_duration *= slow_and_stun_duration_reduction
