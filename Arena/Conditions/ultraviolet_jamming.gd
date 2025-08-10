extends Condition

var palette_lockout_amount: float = 3.0


func _init() -> void:
	name = "Ultraviolet Jamming"
	description = "The penalty for failing a Palette is increased by " + str(palette_lockout_amount) + "s"
	points_per_round = 0


func on_condition_added(condition: Condition) -> void:
	Globals.player.palette.palette_lockout = 6.0


func on_condition_removed(condition: Condition) -> void:
	Globals.player.palette.palette_lockout = 3.0
	
