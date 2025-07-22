class_name BotStateIdle
extends State

var bot: Bot
var desired_location: Vector2

@onready var idle_timer: Timer = $IdleTimer
@onready var roam_timer: Timer = $RoamTimer


func enter() -> void:
	bot = owner as Bot
	assert(bot != null, "The state type must be used only in the Bot scene. It needs the owner to be a Bot node.")

	if !idle_timer.timeout.is_connected(_on_idle_timer_timeout):
		idle_timer.timeout.connect(_on_idle_timer_timeout)
	if !roam_timer.timeout.is_connected(_on_roam_timer_timeout):
		roam_timer.timeout.connect(_on_roam_timer_timeout)
	_set_random_location()
	idle_timer.start(2.0)


func exit() -> void:
	roam_timer.stop()
	idle_timer.stop()


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !bot:
		return
	if !Globals.player:
		return

	if bot.is_stunned():
		idle_timer.paused = true
		roam_timer.paused = true
		return
	idle_timer.paused = false
	roam_timer.paused = false

	if bot.player_is_within_distance(500.0):
		transition.emit("Aggro")

	if roam_timer.is_stopped():
		return

	bot.move_forward(delta, desired_location)


func _on_roam_timer_timeout() -> void:
	idle_timer.start(randf_range(3.0, 5.0))


func _on_idle_timer_timeout() -> void:
	_set_random_location()
	roam_timer.start(randf_range(1.0, 3.0))


func _set_random_location() -> void:
	var vector_to_player := (Globals.player.global_position - bot.global_position).normalized()
	var random_x := bot.global_position.x + randf_range(-300.0, 300.0) + vector_to_player.x * randf_range(50.0, 100.0)
	var random_y := bot.global_position.y + randf_range(-300.0, 300.0) + vector_to_player.y * randf_range(50.0, 100.0)

	desired_location = Vector2(clampf(random_x, 100.0, 3740.0), clampf(random_y, 100.0, 2060.0))
