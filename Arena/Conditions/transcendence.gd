extends Condition

var hit_invulnerable_time: float = 2.0


func _init() -> void:
	name = "Transcendence"
	description = "Enemies become invulnerable for " + str(hit_invulnerable_time) + "s after taking damage"
	points_per_round = 3


func on_enemy_received_damage(_bullet: Bullet, enemy: Enemy) -> void:
	enemy.set_invulnerable(hit_invulnerable_time)
