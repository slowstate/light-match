class_name Tank
extends Enemy

const TANK: PackedScene = preload("res://Enemies/Tank/tank.tscn")


static func create(initial_position: Vector2, initial_health: int, initial_colour: Globals.Colour = Globals.pick_random_colour()) -> Tank:
	var new_tank: Tank = TANK.instantiate()
	new_tank.global_position = initial_position
	new_tank.health = initial_health
	new_tank.colour = initial_colour
	new_tank.move_speed = randf_range(100.0, 125.0)
	new_tank.rotation_speed = randf_range(0.5, 1.0)
	return new_tank
