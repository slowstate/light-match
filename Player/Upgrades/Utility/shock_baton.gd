extends Upgrade

var effect_timer: Timer
var trigger_timer: Timer


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.SHOCK_BATON
	name = "Shock Baton"
	description = "After standing still for 2s, your bullets knock back enemies for 10s"
	icon = preload("res://Player/Upgrades/Utility/Shock Baton.png")
	trigger_timer = super.new_timer()
	effect_timer = super.new_timer()
	effect_timer.connect("timeout", _on_effect_timer_timeout)


func on_enemy_hit(_bullet: Bullet, enemy: Enemy = null) -> void:
	if is_active and enemy != null:
		enemy.knock_back(300.0, 1.0)


func on_player_moving(is_moving: bool) -> void:
	if !is_moving and trigger_timer.is_stopped():
		is_active = true
		effect_timer.start(10)
	if is_moving:
		trigger_timer.start(2)


func _on_effect_timer_timeout() -> void:
	is_active = false
