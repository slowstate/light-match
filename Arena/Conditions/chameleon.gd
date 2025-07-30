extends Condition

var chance_to_change_colour: float = 0.5


func _init() -> void:
	name = "Chameleon"
	description = "Enemies have a " + str(chance_to_change_colour * 100) + "% chance to change to a different colour after taking damage"
	points_per_round = 2


func on_enemy_received_damage(_bullet: Bullet, enemy: Enemy) -> void:
	if enemy.health > 0 and randi() % 2 == 0:
		var different_colours = Globals.Colour.values()
		different_colours.erase(enemy.colour)
		enemy.set_colour(different_colours.pick_random())
