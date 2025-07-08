extends Condition

var speed_increase: float


func _init() -> void:
	name = "Supercharged"
	speed_increase = snappedf(randf_range(0.05, 0.15), 0.01)
	description = "Enemies move " + str(speed_increase * 100) + "% faster"
	points_per_round = 1 if speed_increase < 0.1 else 2


func on_enemy_spawned(enemy: Enemy) -> void:
	enemy.move_speed *= 1 + speed_increase
