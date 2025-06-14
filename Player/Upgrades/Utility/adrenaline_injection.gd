extends Upgrade

@warning_ignore("enum_variable_without_default")
var last_killed_colour: Globals.Colour
var effect_timer: Timer
var number_of_same_colour_kills_in_a_row: int = 0


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.ADRENALINE_INJECTION
	name = "Adrenaline Injection"
	description = "Killing 2 enemies of the same colour in a row grants 20% move speed for 3s"
	icon = preload("res://Player/Upgrades/Utility/Adrenaline Injection.png")
	effect_timer = super.new_timer()
	effect_timer.connect("timeout", _on_effect_timer_timeout)


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(number_of_same_colour_kills_in_a_row)


func on_enemy_killed(enemy: Enemy) -> void:
	if enemy.colour != last_killed_colour:
		number_of_same_colour_kills_in_a_row = 0
	last_killed_colour = enemy.colour
	number_of_same_colour_kills_in_a_row += 1
	if number_of_same_colour_kills_in_a_row >= 2:
		Globals.player.move_speed *= 1.2
		effect_timer.start(3)
		SignalBus.upgrade_activated.emit(self)
		number_of_same_colour_kills_in_a_row = 0
	upgrade_counter_updated.emit(number_of_same_colour_kills_in_a_row)


func _on_effect_timer_timeout() -> void:
	Globals.player.move_speed /= 1.2
	SignalBus.upgrade_deactivated.emit(self)


func on_upgrade_removed(removed_upgrade: Upgrade) -> void:
	if removed_upgrade == self and !effect_timer.is_stopped():
		Globals.player.move_speed /= 1.2
