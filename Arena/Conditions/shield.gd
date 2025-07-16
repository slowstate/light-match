extends Condition

var spawn_immunity_time: int = 5


func _init() -> void:
	name = "Shield"
	description = "Enemies are invulnerable for " + str(spawn_immunity_time) + "s after they spawn"
	points_per_round = 1


func on_enemy_spawned(enemy: Enemy) -> void:
	enemy.immunity_timer.start(spawn_immunity_time)
