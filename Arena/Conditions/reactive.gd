extends Condition

var heal_amount: int = 1


func _init() -> void:
	name = "Reactive"
	description = "Enemies heal " + str(heal_amount) + " HP when hit by a different colour"
	points_per_round = 1


func on_enemy_hit(bullet: Bullet, enemy: Enemy) -> void:
	if bullet.colour != enemy.colour:
		enemy.set_health(enemy.health + 1)
