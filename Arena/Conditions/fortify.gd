extends Condition

var health_increase: float = 0.5


func _init() -> void:
	name = "Fortify"
	description = "Enemies have " + str(health_increase * 100) + "% additional HP"
	points_per_round = 1


func on_enemy_spawned(enemy: Enemy) -> void:
	enemy.base_health = mini(ceili(enemy.base_health * (1 + health_increase)), enemy.max_health)
