class_name BotStateAggro
extends State

var bot: Bot
var aggro_time: float = 5.0
var aggro_cooldown_time: float = 3.0

@onready var aggro_timer: Timer = $AggroTimer
@onready var aggro_cooldown_timer: Timer = $AggroCooldownTimer


func enter() -> void:
	bot = owner as Bot
	assert(bot != null, "The state type must be used only in the Bot scene. It needs the owner to be a Bot node.")
	if !aggro_timer.timeout.is_connected(_on_aggro_timer_timeout):
		aggro_timer.timeout.connect(_on_aggro_timer_timeout)
	if !aggro_cooldown_timer.timeout.is_connected(_on_aggro_cooldown_timer_timeout):
		aggro_cooldown_timer.timeout.connect(_on_aggro_cooldown_timer_timeout)
	aggro_timer.start(aggro_time)


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
		bot.move_forward(
			delta, Globals.player.global_position, lerpf(bot.move_speed, 350.0, ease(1 - aggro_timer.time_left / aggro_timer.wait_time, -2.0) * 2.0)
		)

	if bot.global_position.distance_to(Globals.player.global_position) <= 20.0:
		aggro_timer.stop()
		_on_aggro_timer_timeout()


func _on_aggro_timer_timeout() -> void:
	aggro_cooldown_timer.start(aggro_cooldown_time)
	bot.sleeping = true
	bot.play_move_animation(false)


func _on_aggro_cooldown_timer_timeout() -> void:
	transition.emit("Idle")
