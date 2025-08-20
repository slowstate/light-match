extends Condition


func _init() -> void:
	name = tr("CONDITION_FREQUENCY_DISRUPTION_NAME")
	description = tr("CONDITION_FREQUENCY_DISRUPTION_DESCRIPTION")
	added_dialogue = tr("CONDITION_FREQUENCY_DISRUPTION_DIALOGUE")
	points_per_round = 0


func on_player_received_damage() -> void:
	if Globals.player.palette.failed_cooldown_timer.is_stopped():
		Globals.player.palette.on_palette_failed()
