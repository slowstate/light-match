class_name StarStateIdle
extends State

var star: Star
var idle_time: float = 2.0
@onready var timer: Timer = $Timer


func enter() -> void:
	star = owner as Star
	assert(star != null, "The state type must be used only in the Star scene. It needs the owner to be a Star node.")
	if !timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	timer.start(idle_time)


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
	star.rotate_star(delta, star.shell_rotation_speed)


func _on_timer_timeout() -> void:
	transition.emit("Charge")
