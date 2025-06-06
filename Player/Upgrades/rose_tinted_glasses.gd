extends Upgrade

var enemies_alive_by_colour: Dictionary = {Globals.Colour.BLUE: 0, Globals.Colour.GREEN: 0, Globals.Colour.RED: 0}


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.ROSE_TINTED_GLASSES
	name = "Rose-Tinted Glasses"
	description = "While all enemies are the same colour, your bullets deal 1 more damage"


func on_enemy_spawned(enemy: Enemy) -> Enemy:
	enemies_alive_by_colour[enemy.colour] += 1
	return enemy


func on_enemy_killed(enemy: Enemy) -> Enemy:
	enemies_alive_by_colour[enemy.colour] -= 1
	return enemy


func on_bullet_fired(bullet: Bullet) -> Bullet:
	var number_of_colours_with_enemies_alive = 0
	for key in enemies_alive_by_colour.keys():
		if enemies_alive_by_colour[key] > 0:
			number_of_colours_with_enemies_alive += 1
	if number_of_colours_with_enemies_alive <= 1:
		bullet.damage += 1

	return bullet
