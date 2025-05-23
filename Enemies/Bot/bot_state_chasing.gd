class_name BotStateChasing
extends State

var bot: Bot


func enter() -> void:
	bot = owner as Bot
	assert(bot != null, "The state type must be used only in the Bot scene. It needs the owner to be a Bot node.")


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !bot:
		return
	if !Globals.player:
		return

	var direction_to_player = (Globals.player.global_position - bot.global_position).normalized().angle()
	bot.desired_rotation = direction_to_player
	bot.move_forward(delta)
