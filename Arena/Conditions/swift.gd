extends Condition

var chance_to_ignore_slow: float = 0.33


func _init() -> void:
	name = "Swift"
	description = "Enemies have a " + str(chance_to_ignore_slow * 100) + "% chance to ignore slows "
	points_per_round = 1


func on_enemy_pre_slowed(enemy: Enemy, move_speed_effect: MoveSpeedEffect) -> void:
	if randf_range(0.0, 1.0) <= chance_to_ignore_slow:
		move_speed_effect.effect_amount = 0.0
