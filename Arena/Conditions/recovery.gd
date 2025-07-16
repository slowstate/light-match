extends Condition

var heal_amount: int = 1


func _init() -> void:
	name = "Recovery"
	description = "Enemies heal " + str(heal_amount) + " HP when they receive a slow or freeze"
	points_per_round = 1


func on_enemy_slowed(enemy: Enemy) -> void:
	enemy.set_health(enemy.health + heal_amount)


func on_enemy_stunned(enemy: Enemy) -> void:
	enemy.set_health(enemy.health + heal_amount)
