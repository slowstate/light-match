class_name TankStateIdle
extends State

var tank: Tank

@onready var timer: Timer = $Timer


func enter() -> void:
	tank = owner as Tank
	assert(tank != null, "The state type must be used only in the Tank scene. It needs the owner to be a Tank node.")
	tank.sleeping = true
	if !timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	timer.start(randf_range(1.0, 3.0))


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	transition.emit("Roam")
