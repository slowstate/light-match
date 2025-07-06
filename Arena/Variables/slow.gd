extends Variable

var speed_decrease: float


# TODO: Removce this - for development purposes only
func _init() -> void:
	name = "Slow"
	speed_decrease = snappedf(randf_range(0.01, 0.05), 0.01)
	description = "Player moves " + str(speed_decrease * 100) + "% slower"
	points_per_round = 1 if speed_decrease < 0.03 else 2


func on_variable_added(new_variable: Variable) -> void:
	if new_variable == self:
		Globals.player.move_speed *= 1 - speed_decrease
