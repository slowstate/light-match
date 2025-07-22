class_name TankStateRoam
extends State

var tank: Tank
var desired_location: Vector2
var move_speed := randf_range(80.0, 120.0)

@onready var timer: Timer = $Timer


func enter() -> void:
	tank = owner as Tank
	assert(tank != null, "The state type must be used only in the Tank scene. It needs the owner to be a Tank node.")

	if !timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	_set_random_location()
	timer.start(randf_range(2.0, 4.0))


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !tank:
		return
	if !Globals.player:
		return
	if tank.is_stunned():
		timer.paused = true
		return
	timer.paused = false

	tank.move_forward(delta, desired_location, move_speed)


func _on_timer_timeout() -> void:
	transition.emit("Idle")


func _set_random_location() -> void:
	var vector_to_player := (Globals.player.global_position - tank.global_position).normalized()
	var random_x := tank.global_position.x + randf_range(-300.0, 300.0) + vector_to_player.x * randf_range(50.0, 100.0)
	var random_y := tank.global_position.y + randf_range(-300.0, 300.0) + vector_to_player.y * randf_range(50.0, 100.0)

	desired_location = Vector2(clampf(random_x, 100.0, 3740.0), clampf(random_y, 100.0, 2060.0))
