class_name Star
extends Enemy

const STAR: PackedScene = preload("res://Enemies/Star/star.tscn")

@export var shell_colours: Array[Globals.Colour]
@export var shell_rotation_speed := 1.0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var shells: Node2D = $Shells


static func create(
	initial_position: Vector2,
	initial_health: int,
	initial_colour: Globals.Colour = Globals.pick_random_colour(),
	initial_shell_colours: Array[Globals.Colour] = []
) -> Star:
	var new_star: Star = STAR.instantiate()
	new_star.global_position = initial_position
	new_star.health = initial_health
	new_star.colour = initial_colour
	new_star.shell_colours = initial_shell_colours
	new_star.move_speed = randf_range(200.0, 300.0)
	new_star.rotation_speed = randf_range(1.0, 2.0)
	if new_star.shell_colours.size() != 5:
		new_star.shell_colours.resize(5)
	for shell_number in new_star.shell_colours.size():
		new_star.shell_colours[shell_number] = Globals.pick_random_colour()
	return new_star


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _update(delta: float) -> void:
	_rotate_star(delta, shell_rotation_speed)


func _rotate_star(delta, shell_rotation_speed) -> void:
	sprite.rotate(delta * shell_rotation_speed)
	collision_shape_2d.rotate(delta * shell_rotation_speed)
	shells.rotate(delta * shell_rotation_speed)
