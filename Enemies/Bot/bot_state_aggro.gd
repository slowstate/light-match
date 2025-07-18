class_name BotStateAggro
extends State

var bot: Bot

@onready var aggro_timer: Timer = $AggroTimer
@onready var aggro_cooldown_timer: Timer = $AggroCooldownTimer


func enter() -> void:
	bot = owner as Bot
	assert(bot != null, "The state type must be used only in the Bot scene. It needs the owner to be a Bot node.")
	if !aggro_timer.timeout.is_connected(_on_aggro_timer_timeout):
		aggro_timer.timeout.connect(_on_aggro_timer_timeout)
	if !aggro_cooldown_timer.timeout.is_connected(_on_aggro_cooldown_timer_timeout):
		aggro_cooldown_timer.timeout.connect(_on_aggro_cooldown_timer_timeout)
	aggro_timer.start(5.0)


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !bot:
		return
	if !Globals.player:
		return

	if !aggro_timer.is_stopped():
		bot.move_forward(delta, Globals.player.global_position, 350.0)

	if bot.global_position.distance_to(Globals.player.global_position) <= 20.0:
		aggro_timer.stop()
		_on_aggro_timer_timeout()


func _on_aggro_timer_timeout() -> void:
	aggro_cooldown_timer.start(3.0)
	bot.sleeping = true
	bot.play_move_animation(false)


func _on_aggro_cooldown_timer_timeout() -> void:
	transition.emit("Idle")
