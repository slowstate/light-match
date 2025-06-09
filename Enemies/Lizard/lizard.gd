class_name Lizard
extends Enemy

@export var head_colour: Globals.Colour

const LIZARD: PackedScene = preload("res://Enemies/Lizard/lizard.tscn")


static func create(
	initial_position: Vector2,
	initial_health: int,
	initial_colour: Globals.Colour = Globals.pick_random_colour(),
	initial_head_colour: Globals.Colour = Globals.pick_random_colour()
) -> Lizard:
	var new_lizard: Lizard = LIZARD.instantiate()
	new_lizard.colour = initial_colour
	new_lizard.health = initial_health
	new_lizard.head_colour = initial_head_colour
	new_lizard.global_position = initial_position
	new_lizard.move_speed = randf_range(150.0, 200.0)
	new_lizard.rotation_speed = randf_range(1.0, 1.5)
	return new_lizard


func _setup() -> void:
	sprite.set_head_colour(head_colour)
