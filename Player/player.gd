class_name Player
extends CharacterBody2D

const JUMP_VELOCITY := -400.0

var move_speed := 500.0
var current_colour := Globals.Colour.BLUE

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	Globals.player = self


func _physics_process(_delta: float) -> void:
	var move_vec: Vector2
	if Input.is_action_pressed("player_move_up"):
		move_vec.y = -1
	if Input.is_action_pressed("player_move_left"):
		move_vec.x = -1
	if Input.is_action_pressed("player_move_down"):
		move_vec.y = 1
	if Input.is_action_pressed("player_move_right"):
		move_vec.x = 1
	move_vec = move_vec.normalized()

	velocity = move_vec * move_speed
	sprite_2d.rotation = -velocity.angle()
	collision_shape_2d.rotation = -velocity.angle()

	move_and_slide()


func _input(event: InputEvent) -> void:
	# Handle colour switching
	if event.is_action_pressed("player_red"):
		current_colour = Globals.Colour.RED
	if event.is_action_pressed("player_green"):
		current_colour = Globals.Colour.GREEN
	if event.is_action_pressed("player_blue"):
		current_colour = Globals.Colour.BLUE

	# Handle shooting
	if event.is_action_pressed("player_shoot"):
		_fire_bullet()

	# TODO: Add next and previous colour controls
	#if event.is_action_pressed("player_next_colour"):
	#var bulletColours = Globals.Colour.values()


func _fire_bullet():
	var direction_vector: Vector2 = (get_global_mouse_position() - global_position).normalized()
	var new_bullet: Bullet
	match current_colour:
		Globals.Colour.BLUE:
			new_bullet = BlueBullet.create(global_position, direction_vector)
		Globals.Colour.GREEN:
			new_bullet = GreenBullet.create(global_position, direction_vector)
		Globals.Colour.RED:
			new_bullet = RedBullet.create(global_position, direction_vector)
	if new_bullet:
		get_tree().root.add_child(new_bullet)
