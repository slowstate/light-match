extends Condition


func _init() -> void:
	name = "Frequency Disruption"
	description = "When you receive damage from an enemy, you immediately fail your Palette"
	points_per_round = 0


func on_player_received_damage() -> void:
	if Globals.player.palette.failed_cooldown_timer.is_stopped():
		Globals.player.palette.on_palette_failed()
