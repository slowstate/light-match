class_name Bot
extends Enemy

const BOT: PackedScene = preload("res://Enemies/Bot/bot.tscn")


static func create(initial_position: Vector2, initial_health: int, initial_colour: Globals.Colour = Globals.pick_random_colour()) -> Bot:
	var new_bot: Bot = BOT.instantiate()
	new_bot.global_position = initial_position
	new_bot.base_health = initial_health
	new_bot.max_health = 3
	new_bot.colour = initial_colour
	new_bot.move_speed = 100.0  #randf_range(150.0, 250.0)
	return new_bot


func _physics_process(delta: float) -> void:
	# Default movement is overwritten/ignored here, and is delegated to the BotStateMachine
	pass


func play_move_animation(play: bool) -> void:
	sprite.play_move_animation(play)


func play_attack_animation() -> void:
	sprite.play_attack_animation()
