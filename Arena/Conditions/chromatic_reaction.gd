extends Condition

var effect_timer: Timer
var effect_duration: float = 3.0


func _init() -> void:
	name = "Chromatic Reaction"
	description = "Targets change to a different colour after taking damage"
	added_dialogue = "Seems like your optic recognition is working well, let's make those targets a little more dynamic..."
	points_per_round = 0


func on_enemy_received_damage(_bullet: Bullet, enemy: Enemy) -> void:
	enemy.change_colour(effect_duration)
