class_name LizardStateSpawn
extends State

var lizard: Lizard

@onready var timer: Timer = $Timer


func enter() -> void:
	lizard = owner as Lizard
	assert(lizard != null, "The state type must be used only in the Lizard scene. It needs the owner to be a Lizard node.")
	if !timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	timer.start(3)


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	lizard.modulate = lerp(Color(50, 50, 50, 0), Color(1, 1, 1, 1), 1 - timer.time_left / timer.wait_time)


func _on_timer_timeout() -> void:
	lizard.set_colour(lizard.colour)
	lizard.modulate = Color(1, 1, 1, 1)
	lizard.enable_hurtbox(true)
	transition.emit("Walk")
