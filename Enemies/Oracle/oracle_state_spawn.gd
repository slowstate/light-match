class_name OracleStateSpawn
extends State

var oracle: Oracle

@onready var timer: Timer = $Timer


func enter() -> void:
	oracle = owner as Oracle
	assert(oracle != null, "The state type must be used only in the Oracle scene. It needs the owner to be a Oracle node.")
	if !timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	timer.start(3)


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	oracle.modulate = lerp(Color(50, 50, 50, 0), Color(1, 1, 1, 1), 1 - timer.time_left / timer.wait_time)


func _on_timer_timeout() -> void:
	oracle.modulate = Color(1, 1, 1, 1)
	oracle.enable_hurtbox(true)
	transition.emit("Walk")
