class_name Oracle
extends Enemy

const ORACLE: PackedScene = preload("res://Enemies/Oracle/oracle.tscn")

@onready var hurt_box: Area2D = $HurtBox

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
	new_oracle.base_health = initial_health
	new_oracle.max_health = 3
	new_oracle.colour = initial_colour
	new_oracle.orb_colour = initial_orb_colour
	new_oracle.move_speed = randf_range(250.0, 300.0)
	return new_oracle


func rotate_orbs(delta: float, new_orb_rotation_speed: float) -> void:
	orbs.rotate(delta * new_orb_rotation_speed)


func get_appendages() -> Array[Appendage]:
	return [orb_0, orb_1, orb_2, orb_3, orb_4, orb_5]


func enable_hurtbox(enable: bool) -> void:
	hurt_box.set_collision_layer_value(Globals.CollisionLayer.ENEMIES, enable)
	for orb in get_appendages():
		orb.set_collision_layer_value(Globals.CollisionLayer.ENEMIES, enable)
		orb.set_collision_mask_value(Globals.CollisionLayer.BULLETS, enable)
