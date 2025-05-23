class_name Bot
extends Enemy

const BOT: PackedScene = preload("res://Enemies/Bot/bot.tscn")

@onready var sprite_2d: Sprite2D = $Sprite2D


static func create(initial_position: Vector2, initial_colour: Globals.Colour = Globals.pick_random_colour()) -> Bot:
	var new_bot: Bot = BOT.instantiate()
	new_bot.global_position = initial_position
	new_bot.colour = initial_colour
	return new_bot


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
