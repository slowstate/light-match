extends Condition

var health_regen: int = 1
var health_regen_time: int = 10


func _init() -> void:
	name = "Self-repair"
	description = "Enemies regen " + str(health_regen) + " HP every " + str(health_regen_time) + "s"
	points_per_round = 1


func on_enemy_spawned(enemy: Enemy) -> void:
	enemy.health_regen += 1


func on_enemy_hit(bullet: Bullet, enemy: Enemy) -> void:
	if bullet.colour != enemy.colour:
		return
	enemy.regen_timer.start(health_regen_time)
