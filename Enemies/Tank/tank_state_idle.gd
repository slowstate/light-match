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


func physics_update(delta: float) -> void:
	if tank.shield.modulate.a < 1.0:
		tank.shield.modulate.a += delta

	if tank.is_stunned():
		tank.set_stun_indicator_percentage_completion(1 - tank.stunned_timer.time_left / tank.stunned_timer.wait_time)
		tank.enable_stun_indicator(true)
		tank.dim_lights(true)
		return
	tank.enable_stun_indicator(false)
	tank.dim_lights(false)


func _on_timer_timeout() -> void:
	transition.emit("Roam")
