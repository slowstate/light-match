class_name Star
extends Enemy

const STAR: PackedScene = preload("res://Enemies/Star/star.tscn")

@export var shell_colours: Array[Globals.Colour]
@export var shell_rotation_speed := 0.5

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var shells: Node2D = $Shells
@onready var shell_0: Area2D = $Shells/Shell0
@onready var shell_1: Area2D = $Shells/Shell1
@onready var shell_2: Area2D = $Shells/Shell2
@onready var shell_3: Area2D = $Shells/Shell3
@onready var shell_4: Area2D = $Shells/Shell4
@onready var hit_box: Area2D = $HitBox


static func create(
	initial_position: Vector2,
	initial_health: int,
	initial_colour: Globals.Colour = Globals.pick_random_colour(),
	initial_shell_colours: Array[Globals.Colour] = []
) -> Star:
	var new_star: Star = STAR.instantiate()
	new_star.global_position = initial_position
	new_star.base_health = initial_health
	new_star.max_health = 1
	new_star.colour = initial_colour
	new_star.shell_colours = initial_shell_colours
	new_star.move_speed = randf_range(150.0, 200.0)
	if new_star.shell_colours.size() != 5:
		new_star.shell_colours.resize(5)
	for shell_number in new_star.shell_colours.size():
		new_star.shell_colours[shell_number] = Globals.pick_random_colour()
	return new_star


func _physics_process(_delta: float) -> void:
	pass


func rotate_star(delta: float, new_shell_rotation_speed: float) -> void:
	sprite.rotate(delta * new_shell_rotation_speed)
	collision_shape_2d.rotate(delta * new_shell_rotation_speed)
	shells.rotate(delta * new_shell_rotation_speed)


func get_appendages() -> Array[Appendage]:
	return [shell_0, shell_1, shell_2, shell_3, shell_4]
