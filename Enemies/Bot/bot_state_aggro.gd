class_name BotStateAggro
extends State

var bot: Bot
var aggro_time: float = 3.0
var aggro_cooldown_time: float = 1.5
var target_location: Vector2

@onready var aggro_timer: Timer = $AggroTimer
@onready var aggro_cooldown_timer: Timer = $AggroCooldownTimer
@onready var aggro_2_timer: Timer = $Aggro2Timer


func enter() -> void:
	bot = owner as Bot
	assert(bot != null, "The state type must be used only in the Bot scene. It needs the owner to be a Bot node.")

	bot.enable_attack_warning_indicator(true)

	if !aggro_timer.timeout.is_connected(_on_aggro_timer_timeout):
		aggro_timer.timeout.connect(_on_aggro_timer_timeout)
	if !aggro_2_timer.timeout.is_connected(_on_aggro_2_timer_timeout):
		aggro_2_timer.timeout.connect(_on_aggro_2_timer_timeout)
	if !aggro_cooldown_timer.timeout.is_connected(_on_aggro_cooldown_timer_timeout):
		aggro_cooldown_timer.timeout.connect(_on_aggro_cooldown_timer_timeout)
	aggro_timer.start(aggro_time)

	SfxManager.play_sound("BotAggroSFX", -35.0, -33.0, 0.9, 1.0)

func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !bot:
		return
	if !Globals.player:
		return

	bot.dim_lights(clampf(bot.get_dim_lights_amount() - delta * 2.0, 0.0, 1.0))

	if bot.is_stunned():
		transition.emit("Idle")
		aggro_timer.stop()
		aggro_2_timer.stop()
		aggro_cooldown_timer.stop()
		return

	if !aggro_timer.is_stopped():
		bot.move_forward(
			delta,
			Globals.player.global_position,
			lerpf(bot.move_speed, bot.move_speed * 2.5, ease(1 - aggro_timer.time_left / aggro_timer.wait_time, -2.0) * 2.0)
		)
	if !aggro_2_timer.is_stopped():
		bot.move_forward(
			delta,
			Globals.player.global_position,
			lerpf(bot.move_speed * 2.5, bot.move_speed * 0.5, ease(1 - aggro_2_timer.time_left / aggro_2_timer.wait_time, 2.0))
		)

	if !aggro_cooldown_timer.is_stopped():
		bot.set_stun_indicator_percentage_completion(1 - aggro_cooldown_timer.time_left / aggro_cooldown_timer.wait_time)
		bot.dim_lights(ease(1 - aggro_cooldown_timer.time_left / aggro_cooldown_timer.wait_time, 0.2) * 0.5)


func _on_aggro_timer_timeout() -> void:
	target_location = bot.global_position + (Globals.player.global_position - bot.global_position).normalized() * 1000
	aggro_2_timer.start(1.0)


func _on_aggro_2_timer_timeout() -> void:
	bot.enable_attack_warning_indicator(false)
	bot.enable_stun_indicator(true)

	aggro_cooldown_timer.start(aggro_cooldown_time)
	bot.sleeping = true
	bot.play_move_animation(false)


func _on_aggro_cooldown_timer_timeout() -> void:
	bot.enable_stun_indicator(false)
	transition.emit("Idle")


func _on_hurt_box_player_hit() -> void:
	if !aggro_timer.is_stopped() or !aggro_2_timer.is_stopped():
		bot.play_attack_animation()
		aggro_timer.stop()
		aggro_2_timer.stop()
		_on_aggro_2_timer_timeout()
