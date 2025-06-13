class_name Bot
extends Enemy

const BOT: PackedScene = preload("res://Enemies/Bot/bot.tscn")


static func create(initial_position: Vector2, initial_health: int, initial_colour: Globals.Colour = Globals.pick_random_colour()) -> Bot:
	var new_bot: Bot = BOT.instantiate()
	new_bot.global_position = initial_position
	new_bot.health = initial_health
	new_bot.colour = initial_colour
	new_bot.move_speed = randf_range(150.0, 250.0)
	return new_bot
