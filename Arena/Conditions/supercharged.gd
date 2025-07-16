extends Condition

var speed_increase: float = 0.1


func _init() -> void:
	name = "Supercharged"
	description = "Enemies move " + str(speed_increase * 100) + "% faster"
	points_per_round = 1


func on_enemy_spawned(enemy: Enemy) -> void:
	enemy.move_speed *= 1 + speed_increase
