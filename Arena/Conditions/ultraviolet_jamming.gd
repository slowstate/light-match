extends Condition

var palette_lockout_amount: float = 3.0


func _init() -> void:
	name = "Ultraviolet Jamming"
	description = "After failing your Sequence, it takes longer to refresh"
	added_dialogue = "Let's slow your Sequence recovery and see how you do..."
	points_per_round = 0


func on_condition_added(condition: Condition) -> void:
	if condition == self:
		Globals.player.palette.palette_lockout += palette_lockout_amount


func on_condition_removed(condition: Condition) -> void:
	if condition == self:
		Globals.player.palette.palette_lockout -= palette_lockout_amount
