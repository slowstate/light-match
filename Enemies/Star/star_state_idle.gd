class_name StarStateIdle
extends State

@onready var idle_timer: Timer = $IdleTimer
@onready var roam_timer: Timer = $RoamTimer

var star: Star


func enter() -> void:
	star = owner as Star
	assert(star != null, "The state type must be used only in the Star scene. It needs the owner to be a Star node.")

	idle_timer.timeout.connect(_on_idle_timer_timeout)
	roam_timer.timeout.connect(_on_roam_timer_timeout)
	_set_random_direction()
	roam_timer.start(2.0)


func exit() -> void:
	roam_timer.stop()
	idle_timer.stop()


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !star:
		return
	if !Globals.player:
		return

	if star.player_is_within_distance():
		transition.emit("Chasing")

	if roam_timer.is_stopped():
		return

	star.move_forward(delta)


func _on_roam_timer_timeout() -> void:
	idle_timer.start(randf_range(1.5, 2.0))


func _on_idle_timer_timeout() -> void:
	_set_random_direction()
	roam_timer.start(randf_range(0.5, 2.0))


func _set_random_direction() -> void:
	star.desired_rotation = randf() * TAU  # Sets a random desired rotation
