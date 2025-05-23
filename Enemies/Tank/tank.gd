class_name Tank
extends Enemy

const TANK: PackedScene = preload("res://Enemies/Tank/tank.tscn")

@onready var sprite_2d: Sprite2D = $Sprite2D


static func create(initial_position: Vector2, initial_colour: Globals.Colour = Globals.pick_random_colour()) -> Tank:
	var new_tank: Tank = TANK.instantiate()
	new_tank.global_position = initial_position
	new_tank.colour = initial_colour
	return new_tank


# Called when the node enters the scene tree for the first time.
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


func _on_area_entered(area: Area2D) -> void:
	var bullet = area as Bullet
	if bullet.colour != colour:
		return
	health -= 1
	if health <= 0:
		queue_free()
