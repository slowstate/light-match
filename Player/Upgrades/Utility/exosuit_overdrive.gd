extends Upgrade

var effect_timer: Timer
var damage_amount: float = 1.0
var fire_rate_amount: float = 0.5
var effect_duration: float = 10.0
var palettes_cleared_counter: int = 0


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.BIGGER_BULLET
	name = "Exosuit Overdrive"
	description = "After completing 3 Sequences, you gain increased firepower"
	added_dialogue = "Looks like you've reached your ultimate evolution"
	#icon = preload("res://Player/Upgrades/Combat/Exosuit Overdrive.png")
	points_cost = 0
	effect_timer = super.new_timer()
	effect_timer.connect("timeout", _on_effect_timer_timeout)


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(palettes_cleared_counter)


func on_palette_cleared(_palette: Palette) -> void:
	palettes_cleared_counter += 1
	if palettes_cleared_counter >= 3:
		effect_timer.start(effect_duration)
		Globals.player.enable_exosuit_overdrive_aura(true)
		is_active = true
		palettes_cleared_counter = 0
	upgrade_counter_updated.emit(palettes_cleared_counter)


func _on_effect_timer_timeout() -> void:
	is_active = false
	Globals.player.enable_exosuit_overdrive_aura(false)


func on_gun_cooldown_start(gun_cooldown_timer: Timer) -> void:
	if is_active:
		gun_cooldown_timer.start(gun_cooldown_timer.wait_time * (1 / (1 + fire_rate_amount)))


func on_enemy_hit(bullet: Bullet, enemy: Enemy = null) -> void:
	if is_active:
		bullet.damage += 1
