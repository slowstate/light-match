extends Upgrade


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.QUICK_RELEASE_MAG
	name = "Quick Release Mag"
	description = "Changing gun colour reduces your current cooldown by 0.3s"


func on_gun_colour_switch(gun_cooldown_timer: Timer) -> void:
	gun_cooldown_timer.start(clampf(gun_cooldown_timer.time_left - 0.3, 0.01, 0.7))
