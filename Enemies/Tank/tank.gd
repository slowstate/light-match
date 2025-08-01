class_name Tank
extends Enemy

const TANK: PackedScene = preload("res://Enemies/Tank/tank.tscn")

@onready var hurt_box: Area2D = $HurtBox
@onready var shield: Area2D = $Shield


static func create(initial_position: Vector2, initial_health: int, initial_colour: Globals.Colour = Globals.pick_random_colour()) -> Tank:
	var new_tank: Tank = TANK.instantiate()
	new_tank.global_position = initial_position
	new_tank.base_health = initial_health
	new_tank.max_health = 5
	new_tank.colour = initial_colour
	new_tank.move_speed = randf_range(100.0, 125.0)
	return new_tank


func enable_hurtbox(enable: bool) -> void:
	hurt_box.set_collision_layer_value(Globals.CollisionLayer.ENEMIES, enable)
	shield.set_collision_layer_value(Globals.CollisionLayer.TANK_SHIELD, enable)
	shield.set_collision_mask_value(Globals.CollisionLayer.BULLETS, enable)
