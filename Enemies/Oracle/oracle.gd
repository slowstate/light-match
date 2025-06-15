class_name Oracle
extends Enemy

const ORACLE: PackedScene = preload("res://Enemies/Oracle/oracle.tscn")

@export var orb_colour: Globals.Colour = Globals.Colour.BLUE
@export var orb_rotation_speed := 1.0

@onready var orbs: Node2D = $Orbs
@onready var orb_0: Area2D = $Orbs/Orb0
@onready var orb_1: Area2D = $Orbs/Orb1
@onready var orb_2: Area2D = $Orbs/Orb2
@onready var orb_3: Area2D = $Orbs/Orb3
@onready var orb_4: Area2D = $Orbs/Orb4
@onready var orb_5: Area2D = $Orbs/Orb5


static func create(
	initial_position: Vector2,
	initial_health: int,
	initial_colour: Globals.Colour = Globals.pick_random_colour(),
	initial_orb_colour: Globals.Colour = Globals.pick_random_colour()
) -> Oracle:
	var new_oracle: Oracle = ORACLE.instantiate()
	new_oracle.global_position = initial_position
	new_oracle.health = initial_health
	new_oracle.colour = initial_colour
	new_oracle.orb_colour = initial_orb_colour
	new_oracle.move_speed = randf_range(150.0, 200.0)
	return new_oracle


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _update(delta: float) -> void:
	_rotate_orbs(delta, orb_rotation_speed)


func _rotate_orbs(delta: float, new_orb_rotation_speed: float) -> void:
	orbs.rotate(delta * new_orb_rotation_speed)


func get_appendages() -> Array[Appendage]:
	return [orb_0, orb_1, orb_2, orb_3, orb_4, orb_5]
