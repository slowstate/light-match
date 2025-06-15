extends Upgrade

var trigger_timers: Array[Timer]
var colour_switching_enemies: Array[Enemy]


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.COLOUR_CHANGING_DYE
	name = "Colour-Changing Dye"
	description = "Enemies change to a different colour every 15s"
	icon = preload("res://Player/Upgrades/Meta/Colour Changing Dye.png")


func on_upgrade_added(new_upgrade: Upgrade) -> void:
	if new_upgrade == self:
		SignalBus.upgrade_activated.emit(self)


func on_enemy_spawned(enemy: Enemy) -> void:
	var trigger_timer = super.new_timer()
	trigger_timer.connect("timeout", _on_trigger_timer_timeout)
	trigger_timer.start(15)
	trigger_timers.push_back(trigger_timer)
	colour_switching_enemies.push_back(enemy)


func on_enemy_killed(enemy: Enemy) -> void:
	var enemy_index = colour_switching_enemies.find(enemy)
	if enemy_index >= 0:
		var trigger_timer = trigger_timers.pop_at(enemy_index)
		trigger_timer.queue_free()
		colour_switching_enemies.erase(enemy)


func _on_trigger_timer_timeout() -> void:
	var enemy_to_colour_switch = colour_switching_enemies.pop_front() as Enemy
	colour_switching_enemies.push_back(enemy_to_colour_switch)
	var possible_random_colours = Globals.Colour.values().duplicate()
	possible_random_colours.erase(enemy_to_colour_switch.colour)
	enemy_to_colour_switch.set_colour(possible_random_colours.pick_random())
	var trigger_timer = trigger_timers.pop_front() as Timer
	trigger_timers.push_back(trigger_timer)
	trigger_timer.start(15)
