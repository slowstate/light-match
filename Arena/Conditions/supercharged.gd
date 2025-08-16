extends Condition

var speed_increase: float = 0.1


func _init() -> void:
	name = "Supercharged"
	description = "Targets are more aggressive"
	added_dialogue = "Keep up the pace, the targets are going to be more aggressive from here on out..."
	points_per_round = 1


func on_enemy_spawned(enemy: Enemy) -> void:
	enemy.move_speed *= 1 + speed_increase
