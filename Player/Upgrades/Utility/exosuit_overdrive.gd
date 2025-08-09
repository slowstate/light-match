extends Upgrade

var effect_timer: Timer
var damage_amount: float = 1.0
var fire_rate_amount: float = 0.5
var speed_amount: float = 0.2
var effect_duration: float = 10.0
var palettes_cleared_counter: int = 0

func _init() -> void:
	type = UpgradeManager.UpgradeTypes.BIGGER_BULLET
	name = "Exosuit Overdrive"
	description = "After clearing 3 Palettes, you gain " + str(damage_amount) + " bonus damage, " + str(fire_rate_amount * 100) + "% fire rate, " + str(speed_amount * 100) + "% speed, and a shield for 10s"
	#icon = preload("res://Player/Upgrades/Combat/Exosuit Overdrive.png")
	points_cost = 0
	effect_timer = super.new_timer()
	effect_timer.connect("timeout", _on_effect_timer_timeout)


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(palettes_cleared_counter)


func on_palette_cleared(_palette: Palette) -> void:
	palettes_cleared_counter += 1
	if palettes_cleared_counter >= 3:
		if effect_timer.is_stopped():
			effect_timer.start(effect_duration)
			Globals.player.shield_active = true
			is_active = true
			palettes_cleared_counter = 0
			Globals.player.move_speed *= (1 + speed_amount)
		else:
			effect_timer.set_wait_time(effect_duration)


func _on_effect_timer_timeout() -> void:
	Globals.player.move_speed /= (1 + speed_amount)
	is_active = false


func on_gun_cooldown_start(gun_cooldown_timer: Timer) -> void:
	if is_active:
		gun_cooldown_timer.set_wait_time(gun_cooldown_timer.wait_time * (1 / (1 + fire_rate_amount)))


func on_enemy_hit(bullet: Bullet, enemy: Enemy = null) -> void:
	if is_active:
		bullet.damage += 1
