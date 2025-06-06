class_name Bot
extends Enemy

const BOT: PackedScene = preload("res://Enemies/Bot/bot.tscn")

@onready var sprite_2d: Sprite2D = $Sprite2D


static func create(initial_position: Vector2, initial_health: int, initial_colour: Globals.Colour = Globals.pick_random_colour()) -> Bot:
	var new_bot: Bot = BOT.instantiate()
	new_bot.global_position = initial_position
	new_bot.health = initial_health
	new_bot.colour = initial_colour
	new_bot.move_speed = randf_range(200.0, 300.0)
	new_bot.rotation_speed = randf_range(2.0, 2.5)
	return new_bot


# Called when the node enters the scene tree for the first time.
func _setup() -> void:
	_set_sprite_colour()


func _set_sprite_colour() -> void:
	match colour:
		Globals.Colour.BLUE:
			sprite_2d.texture = load("res://Enemies/Colours/Blue/enemy_blue.png")
		Globals.Colour.GREEN:
			sprite_2d.texture = load("res://Enemies/Colours/Green/enemy_green.png")
		Globals.Colour.RED:
			sprite_2d.texture = load("res://Enemies/Colours/Red/enemy_red.png")
