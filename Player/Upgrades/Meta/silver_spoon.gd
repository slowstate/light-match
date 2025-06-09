extends Upgrade

var last_killed_colour: Globals.Colour
var number_of_kills: int = 0


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.SILVER_SPOON
	name = "Silver Spoon"
	description = "After killing 10 enemies, gain a cleared palette"


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(number_of_kills)


func on_enemy_killed(enemy: Enemy) -> void:
	number_of_kills += 1
	if number_of_kills >= 10:
		SignalBus.palette_cleared.emit()
		UpgradeManager.on_palette_cleared(Globals.player.palette)
		number_of_kills = 0
	upgrade_counter_updated.emit(number_of_kills)
