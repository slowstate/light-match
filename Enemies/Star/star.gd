class_name Star
extends Enemy

const STAR: PackedScene = preload("res://Enemies/Star/star.tscn")

@export var wall_colours: Array[Globals.Colour]
@export var wall_rotation_speed := 1.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var walls: Node2D = $Walls


static func create(
	initial_position: Vector2, initial_colour: Globals.Colour = Globals.pick_random_colour(), initial_wall_colours: Array[Globals.Colour] = []
) -> Star:
	var new_star: Star = STAR.instantiate()
	new_star.global_position = initial_position
	new_star.colour = initial_colour
	new_star.wall_colours = initial_wall_colours
	if new_star.wall_colours.size() < 5:
		new_star.wall_colours.resize(5)
		for wall_number in new_star.wall_colours.size():
			new_star.wall_colours[wall_number] = Globals.pick_random_colour()
	return new_star


func _setup() -> void:
	_set_sprite_colour()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_to_target(delta, desired_rotation)
	_rotate_star(delta, wall_rotation_speed)


func _set_sprite_colour() -> void:
	match colour:
		Globals.Colour.BLUE:
			sprite_2d.texture = load("res://Enemies/Colours/Blue/enemy_blue.png")
		Globals.Colour.GREEN:
			sprite_2d.texture = load("res://Enemies/Colours/Green/enemy_green.png")
		Globals.Colour.RED:
			sprite_2d.texture = load("res://Enemies/Colours/Red/enemy_red.png")


func _rotate_star(delta, wall_rotation_speed) -> void:
	sprite_2d.rotate(delta * wall_rotation_speed)
	collision_shape_2d.rotate(delta * wall_rotation_speed)
	walls.rotate(delta * wall_rotation_speed)
