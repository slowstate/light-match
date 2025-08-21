extends Condition

var speed_increase: float = 0.1


func _init() -> void:
	name = tr("CONDITION_SUPERCHARGED_NAME")
	description = tr("CONDITION_SUPERCHARGED_DESCRIPTION")
	added_dialogue = tr("CONDITION_SUPERCHARGED_DIALOGUE")
	points_per_round = 1


func on_enemy_spawned(enemy: Enemy) -> void:
	enemy.move_speed *= 1 + speed_increase
