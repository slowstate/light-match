class_name StarStateIdle
extends State

var star: Star
var idle_time: float = 2.0
@onready var timer: Timer = $Timer


func enter() -> void:
	star = owner as Star
	assert(star != null, "The state type must be used only in the Star scene. It needs the owner to be a Star node.")

	star.enable_attack_warning_indicator(false)

	if !timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	timer.start(randf_range(1.5, 3.5))


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !star:
		return
	if !Globals.player:
		return
	if star.is_stunned():
		star.set_stun_indicator_percentage_completion(1 - star.stunned_timer.time_left / star.stunned_timer.wait_time)
		star.enable_stun_indicator(true)
		timer.paused = true
		return
	star.enable_stun_indicator(false)
	timer.paused = false

	star.rotate_star(delta, star.shell_rotation_speed)


func _on_timer_timeout() -> void:
	transition.emit("Charge")
