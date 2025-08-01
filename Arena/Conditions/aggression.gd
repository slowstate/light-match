extends Condition

var damage_increase: float = 0.5


func _init() -> void:
	name = "Aggression"
	description = "Enemies deal " + str(damage_increase * 100) + "% additional damage"
	points_per_round = 2


func on_enemy_spawned(enemy: Enemy) -> void:
	enemy.damage = ceili(enemy.damage * (1 + damage_increase))
