extends Condition

var effect_timer: Timer
var effect_duration: float = 3.0


func _init() -> void:
	name = tr("CONDITION_CHROMATIC_REACTION_NAME")
	description = tr("CONDITION_CHROMATIC_REACTION_DESCRIPTION")
	added_dialogue = tr("CONDITION_CHROMATIC_REACTION_DIALOGUE")
	points_per_round = 0


func on_enemy_received_damage(_bullet: Bullet, enemy: Enemy) -> void:
	enemy.change_colour(effect_duration)
