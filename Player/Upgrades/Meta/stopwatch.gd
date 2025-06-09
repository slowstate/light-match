extends Upgrade


func _init() -> void:
	#type = UpgradeManager.UpgradeTypes.STOPWATCH
	name = "Stopwatch"
	description = "After clearing 7 palettes in a row, prevents new enemies from spawning for 10s"
