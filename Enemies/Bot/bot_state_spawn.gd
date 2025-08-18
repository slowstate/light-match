class_name BotStateSpawn
extends State

var bot: Bot

@onready var timer: Timer = $Timer


func enter() -> void:
	bot = owner as Bot
	assert(bot != null, "The state type must be used only in the Bot scene. It needs the owner to be a Bot node.")

	if !timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	timer.start(3)


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	bot.modulate = lerp(Color(38, 38, 38, 0), Color(1, 1, 1, 1), 1 - timer.time_left / timer.wait_time)


func _on_timer_timeout() -> void:
	bot.set_colour(bot.colour)
	bot.modulate = Color(1, 1, 1, 1)
	bot.enable_hurtbox(true)
	transition.emit("Idle")
