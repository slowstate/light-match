extends Upgrade

var trigger_timer: Timer
var effect_timer: Timer
var is_active: bool = false


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.BIPOD
	name = "Bipod"
	description = "Standing still increases your firerate by 40%"
	icon = preload("res://Player/Upgrades/Combat/Bipod.png")
	trigger_timer = super.new_timer()
	effect_timer = super.new_timer()
	effect_timer.connect("timeout", _on_effect_timer_timeout)


func on_gun_cooldown_start(gun_cooldown_timer: Timer) -> void:
	if trigger_timer.is_stopped():
		gun_cooldown_timer.start(gun_cooldown_timer.wait_time * 0.6)


func on_player_moving(is_moving: bool) -> void:
	if !is_moving and trigger_timer.is_stopped():
		is_active = true
		SignalBus.upgrade_activated.emit(self)
		effect_timer.start(0.5)
	if is_moving:
		trigger_timer.start(0.3)


func _on_effect_timer_timeout() -> void:
	SignalBus.upgrade_deactivated.emit(self)
