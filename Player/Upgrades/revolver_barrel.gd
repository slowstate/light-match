extends Upgrade

var last_killed_colour: Globals.Colour
var number_of_same_colour_kills_in_a_row: int


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.REVOLVER_BARREL
	name = "Revolver Barrel"
	description = "After killing 3 enemies of the same colour in a row, your next bullet deals 1 more damage"


func on_enemy_killed(enemy: Enemy) -> Enemy:
	if enemy.colour != last_killed_colour:
		number_of_same_colour_kills_in_a_row = 0
	last_killed_colour = enemy.colour
	number_of_same_colour_kills_in_a_row += 1
	return enemy


func on_bullet_fired(bullet: Bullet) -> Bullet:
	if number_of_same_colour_kills_in_a_row >= 3:
		bullet.damage += 1
		number_of_same_colour_kills_in_a_row = 0
	return bullet
