extends Upgrade


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.ROSE_TINTED_GLASSES
	name = "Rose-Tinted Glasses"
	description = "While all enemies are the same colour, your bullets instantly kill enemies"
	icon = preload("res://Player/Upgrades/Combat/Rose Tinted Glasses.png")


func on_upgrade_added(new_upgrade: Upgrade) -> void:
	if _all_enemies_alive_are_the_same_colour():
		SignalBus.upgrade_activated.emit(self)
	else:
		SignalBus.upgrade_deactivated.emit(self)


func on_enemy_colour_changed() -> void:
	_emit_upgrade_activated_or_deactivation()


func on_enemy_spawned(enemy: Enemy) -> void:
	_emit_upgrade_activated_or_deactivation()


func on_enemy_killed(enemy: Enemy) -> void:
	_emit_upgrade_activated_or_deactivation([enemy])


func on_bullet_fired(bullet: Bullet) -> void:
	if _all_enemies_alive_are_the_same_colour():
		bullet.damage = 99


func _emit_upgrade_activated_or_deactivation(enemies_to_ignore: Array[Enemy] = []) -> void:
	if _all_enemies_alive_are_the_same_colour(enemies_to_ignore):
		SignalBus.upgrade_activated.emit(self)
	else:
		SignalBus.upgrade_deactivated.emit(self)


func _all_enemies_alive_are_the_same_colour(enemies_to_ignore: Array[Enemy] = []) -> bool:
	var all_enemies_alive = Globals.get_all_enemies_alive()
	for enemy in enemies_to_ignore:
		all_enemies_alive.erase(enemy)
	var enemies_alive_by_colour: Dictionary = {Globals.Colour.BLUE: 0, Globals.Colour.GREEN: 0, Globals.Colour.RED: 0}
	for enemy in all_enemies_alive:
		enemies_alive_by_colour[enemy.colour] += 1

	var number_of_colours_with_enemies_alive = 0
	for key in enemies_alive_by_colour.keys():
		if enemies_alive_by_colour[key] > 0:
			number_of_colours_with_enemies_alive += 1
	if number_of_colours_with_enemies_alive <= 1:
		return true
	return false
