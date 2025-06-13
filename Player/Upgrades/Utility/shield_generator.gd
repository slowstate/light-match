extends Upgrade

var palettes_cleared_in_a_row: int = 0
var effect_timers: Array[Timer]
var slowed_enemies: Array[Enemy]


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.SHIELD_GENERATOR
	name = "Shield Generator"
	description = "After clearing 3 palettes in a row, gain 1 shield. When your shield breaks, slows all nearby enemies by 50% for 10s"
	icon = preload("res://Player/Upgrades/Utility/Shield Generator.png")


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_palette_cleared(_palette: Palette) -> void:
	palettes_cleared_in_a_row += 1
	if palettes_cleared_in_a_row >= 3:
		Globals.player.shield_active = true
		SignalBus.upgrade_activated.emit(self)
		palettes_cleared_in_a_row = 0
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_palette_failed() -> void:
	palettes_cleared_in_a_row = 0
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_player_shield_break() -> void:
	var all_enemies_alive = Globals.get_all_enemies_alive()
	for enemy in all_enemies_alive:
		if (enemy.global_position - Globals.player.global_position).length() < 500.0:
			slowed_enemies.push_back(enemy)
			var effect_timer = super.new_timer()
			effect_timer.connect("timeout", _on_effect_timer_timeout)
			effect_timer.start(10)
			effect_timers.push_back(effect_timer)
			enemy.move_speed *= 0.5
	SignalBus.upgrade_deactivated.emit(self)


func _on_effect_timer_timeout() -> void:
	if slowed_enemies.is_empty():
		return
	var slowed_enemy = slowed_enemies.pop_front()
	if is_instance_valid(slowed_enemy):
		slowed_enemy = slowed_enemy as Enemy
		slowed_enemy.move_speed /= 0.5
	var effect_timer = effect_timers.pop_front() as Timer
	effect_timer.queue_free()


func on_upgrade_removed(removed_upgrade: Upgrade) -> void:
	if removed_upgrade == self:
		for enemy in slowed_enemies:
			enemy.move_speed /= 0.5
