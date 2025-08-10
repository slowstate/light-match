extends Condition

var effect_timer: Timer
var effect_duration: float = 3.0

func _init() -> void:
	name = "Chromatic Reaction"
	description = "Enemies change to a different colour " + str(effect_duration) + "s after taking damage"
	points_per_round = 0


func on_enemy_received_damage(_bullet: Bullet, enemy: Enemy) -> void:
	enemy.change_colour(effect_duration)
