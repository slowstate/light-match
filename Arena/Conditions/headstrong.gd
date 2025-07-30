extends Condition

var chance_to_ignore_stun: float = 0.2


func _init() -> void:
	name = "Headstrong"
	description = "Enemies have a " + str(chance_to_ignore_stun * 100) + "% chance to ignore stuns"
	points_per_round = 1


func on_enemy_pre_stunned(enemy: Enemy, stun_effect: StunEffect) -> void:
	if randf_range(0.0, 1.0) <= chance_to_ignore_stun:
		stun_effect.effect_duration = 0.0
