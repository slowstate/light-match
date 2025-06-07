class_name Oracle
extends Enemy

const ORACLE: PackedScene = preload("res://Enemies/Oracle/oracle.tscn")

@export var orb_colour: Globals.Colour
@export var orb_rotation_speed := 1.0

@onready var orbs: Node2D = $Orbs


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
	new_oracle.move_speed = randf_range(200.0, 300.0)
	new_oracle.rotation_speed = randf_range(1.0, 2.0)
	return new_oracle


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _update(delta: float) -> void:
	_rotate_orbs(delta, orb_rotation_speed)


func _rotate_orbs(delta, orb_rotation_speed) -> void:
	orbs.rotate(delta * orb_rotation_speed)
