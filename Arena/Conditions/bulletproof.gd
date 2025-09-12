extends Condition

var chance_to_ignore_damage: float = 0.2


func _init() -> void:
	name = "Bulletproof"
	description = "Enemies have a " + str(chance_to_ignore_damage * 100) + "% chance to ignore damage received "
	points_per_round = 3


func on_enemy_spawned(enemy: Enemy) -> void:
	enemy.health_regen += 1


func on_enemy_hit(bullet: Bullet, _enemy: Enemy) -> void:
	if randf_range(0.0, 1.0) < chance_to_ignore_damage:
		bullet.damage = 0
