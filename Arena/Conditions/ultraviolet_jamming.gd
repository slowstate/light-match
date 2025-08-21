extends Condition

var palette_lockout_amount: float = 3.0


func _init() -> void:
	name = tr("CONDITION_ULTRAVIOLET_JAMMING_NAME")
	description = tr("CONDITION_ULTRAVIOLET_JAMMING_DESCRIPTION")
	added_dialogue = tr("CONDITION_ULTRAVIOLET_JAMMING_DIALOGUE")
	points_per_round = 0


func on_condition_added(condition: Condition) -> void:
	if condition == self:
		Globals.player.palette.palette_lockout += palette_lockout_amount


func on_condition_removed(condition: Condition) -> void:
	if condition == self:
		Globals.player.palette.palette_lockout -= palette_lockout_amount
