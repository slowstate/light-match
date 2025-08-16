extends Condition


func _init() -> void:
	name = "Frequency Disruption"
	description = "When you're hit, you fail your current Sequence"
	added_dialogue = "Impressive! One final test. Physical trauma now disrupts your current Sequence..."
	points_per_round = 0


func on_player_received_damage() -> void:
	if Globals.player.palette.failed_cooldown_timer.is_stopped():
		Globals.player.palette.on_palette_failed()
