extends Upgrade

var trigger_timer: Timer


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.BIPOD
	name = "Bipod"
	description = "Standing still for 3s reduces your cooldowns by 0.1s"
	trigger_timer = super.new_timer()
	trigger_timer.start(3)


func on_gun_cooldown_start(gun_cooldown_timer: Timer) -> Timer:
	# Reduces the gun cooldown TO 0.6s (0.7s-0.1s)
	if trigger_timer.is_stopped():
		if gun_cooldown_timer.wait_time > 0.6:
			gun_cooldown_timer.wait_time = 0.6
	return gun_cooldown_timer


func on_player_moving() -> void:
	trigger_timer.start(3)
