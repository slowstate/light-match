class_name StarStateCharge
extends State

var star: Star

var charge_time: float = 3.0
var charge_shell_rotation_speed: float

@onready var timer: Timer = $Timer


func enter() -> void:
	star = owner as Star
	assert(star != null, "The state type must be used only in the Star scene. It needs the owner to be a Star node.")

	star.enable_attack_warning_indicator(true)

	charge_shell_rotation_speed = star.shell_rotation_speed
	if !timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	timer.start(charge_time)


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
		timer.paused = true
		return
	timer.paused = false

	charge_shell_rotation_speed = lerpf(star.shell_rotation_speed, star.shell_rotation_speed * 50.0, ease(1 - timer.time_left / timer.wait_time, 2.0))
	star.rotate_star(delta, charge_shell_rotation_speed)


func _on_timer_timeout() -> void:
	transition.emit("Teleport")
