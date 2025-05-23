class_name TankStateIdle
extends State

@onready var idle_timer: Timer = $IdleTimer
@onready var roam_timer: Timer = $RoamTimer

var tank: Tank


func enter() -> void:
	tank = owner as Tank
	assert(tank != null, "The state type must be used only in the Tank scene. It needs the owner to be a Tank node.")

	idle_timer.timeout.connect(_on_idle_timer_timeout)
	roam_timer.timeout.connect(_on_roam_timer_timeout)
	_set_random_direction()
	roam_timer.start(1.0)


func exit() -> void:
	roam_timer.stop()
	idle_timer.stop()


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !tank:
		return
	if !Globals.player:
		return

	_if_player_is_within_distance_then_change_state_to_chasing()

	if roam_timer.is_stopped():
		return

	tank.move_forward(delta)


func _on_roam_timer_timeout() -> void:
	idle_timer.start(randf_range(1.5, 2.0))


func _on_idle_timer_timeout() -> void:
	_set_random_direction()
	roam_timer.start(randf_range(0.5, 2.0))


func _set_random_direction() -> void:
	tank.desired_rotation = randf() * TAU  # Sets a random desired rotation


func _if_player_is_within_distance_then_change_state_to_chasing(distance := 500.0) -> void:
	if (tank.global_position - Globals.player.global_position).length() < distance:
		transition.emit("Chasing")
