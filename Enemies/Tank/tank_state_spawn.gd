class_name TankStateSpawn
extends State

var tank: Tank

@onready var timer: Timer = $Timer


func enter() -> void:
	tank = owner as Tank
	assert(tank != null, "The state type must be used only in the Tank scene. It needs the owner to be a Tank node.")
	if !timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	timer.start(3)


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	tank.modulate = lerp(Color(16, 16, 16, 0), Color(1, 1, 1, 1), 1 - timer.time_left / timer.wait_time)


func _on_timer_timeout() -> void:
	tank.set_colour(tank.colour)
	tank.modulate = Color(1, 1, 1, 1)
	tank.enable_hurtbox(true)
	transition.emit("Idle")
