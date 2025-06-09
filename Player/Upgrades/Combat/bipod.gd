extends Upgrade

var trigger_timer: Timer


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.BIPOD
	name = "Bipod"
	description = "Standing still for 1s reduces your cooldowns by 0.3s"
	trigger_timer = super.new_timer()


func on_gun_cooldown_start(gun_cooldown_timer: Timer) -> void:
	# Reduces the gun cooldown TO 0.4s (0.7s-0.3s)
	if trigger_timer.is_stopped():
		if gun_cooldown_timer.wait_time > 0.4:
			gun_cooldown_timer.wait_time = 0.4


func on_player_moving(is_moving: bool) -> void:
	if is_moving:
		trigger_timer.start(1)
