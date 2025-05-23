class_name Lizard
extends Enemy

const LIZARD: PackedScene = preload("res://Enemies/Lizard/lizard.tscn")

@export var head_colour: Globals.Colour

@onready var sprite_2d: Sprite2D = $Sprite2D


static func create(
	initial_position: Vector2, initial_colour: Globals.Colour = Globals.pick_random_colour(), initial_head_colour: Globals.Colour = Globals.pick_random_colour()
) -> Lizard:
	var new_lizard: Lizard = LIZARD.instantiate()
	new_lizard.colour = initial_colour
	new_lizard.head_colour = initial_head_colour
	new_lizard.global_position = initial_position
	return new_lizard


func _setup() -> void:
	_set_sprite_colour()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_to_target(delta, desired_rotation)


func _set_sprite_colour() -> void:
	match colour:
		Globals.Colour.BLUE:
			sprite_2d.texture = load("res://Enemies/Colours/Blue/enemy_blue.png")
		Globals.Colour.GREEN:
			sprite_2d.texture = load("res://Enemies/Colours/Green/enemy_green.png")
		Globals.Colour.RED:
			sprite_2d.texture = load("res://Enemies/Colours/Red/enemy_red.png")
