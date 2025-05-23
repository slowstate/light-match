class_name Oracle
extends Enemy

const ORACLE: PackedScene = preload("res://Enemies/Oracle/oracle.tscn")

@export var orb_colour: Globals.Colour
@export var orb_rotation_speed := 1.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var orbs: Node2D = $Orbs


static func create(
	initial_position: Vector2, initial_colour: Globals.Colour = Globals.pick_random_colour(), initial_orb_colour: Globals.Colour = Globals.pick_random_colour()
) -> Oracle:
	var new_oracle: Oracle = ORACLE.instantiate()
	new_oracle.global_position = initial_position
	new_oracle.colour = initial_colour
	new_oracle.orb_colour = initial_orb_colour
	return new_oracle


func _setup() -> void:
	_set_sprite_colour()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_to_target(delta, desired_rotation)
	_rotate_orbs(delta, orb_rotation_speed)


func _set_sprite_colour() -> void:
	match colour:
		Globals.Colour.BLUE:
			sprite_2d.texture = load("res://Enemies/Colours/Blue/enemy_blue.png")
		Globals.Colour.GREEN:
			sprite_2d.texture = load("res://Enemies/Colours/Green/enemy_green.png")
		Globals.Colour.RED:
			sprite_2d.texture = load("res://Enemies/Colours/Red/enemy_red.png")


func _rotate_orbs(delta, orb_rotation_speed) -> void:
	orbs.rotate(delta * orb_rotation_speed)
