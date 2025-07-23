extends Upgrade


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.QUICK_RELEASE_MAG
	name = "Quick Release Mag"
	description = "Changing gun colour instantly readies your gun"
	icon = preload("res://Player/Upgrades/Combat/Quick Release Mag.png")
	points_cost = 1


func on_upgrade_added(new_upgrade: Upgrade) -> void:
	if new_upgrade == self:
		is_active = true


func on_gun_colour_switch(gun_cooldown_timer: Timer) -> void:
	gun_cooldown_timer.start(0.01)
