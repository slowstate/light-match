extends Condition

var maximum_health_reduction: int = 1


func _init() -> void:
	name = "Brittle"
	description = "Your maximum HP is reduced by " + str(maximum_health_reduction) + " HP (minimum Max HP 1)"
	points_per_round = 3


func on_condition_added(condition: Condition) -> void:
	Globals.player.base_health = maxi(Globals.player.base_health - 1, 1)
