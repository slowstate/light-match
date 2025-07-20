class_name LizardStateShortDash
extends State

var lizard: Lizard
var target_location: Vector2
var dashing: bool = false

@onready var timer: Timer = $Timer
@onready var stun_timer: Timer = $StunTimer


func enter() -> void:
	lizard = owner as Lizard
	assert(lizard != null, "The state type must be used only in the Lizard scene. It needs the owner to be a Lizard node.")
	dashing = false
	lizard.sleeping = true
	target_location = lizard.global_position + (Globals.player.global_position - lizard.global_position).normalized() * randf_range(350.0, 450.0)
	if !timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	if !stun_timer.timeout.is_connected(_on_stun_timer_timeout):
		stun_timer.timeout.connect(_on_stun_timer_timeout)
	timer.start(randf_range(0.2, 0.5))


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if lizard.get_appendages().is_empty():
		transition.emit("AggroDash")
		return
	if !timer.is_stopped():
		lizard.rotation = lerp_angle(lizard.rotation, (target_location - lizard.global_position).angle(), 5.0 * delta)
	if !stun_timer.is_stopped():
		lizard.rotation = lerp_angle(lizard.rotation, (Globals.player.global_position - lizard.global_position).angle(), 3.0 * delta)
	if dashing:
		lizard.global_position = lizard.global_position.lerp(target_location, 5.0 * delta).clamp(Vector2(65, 65), Vector2(3775, 2095))


func _on_timer_timeout() -> void:
	dashing = true
	stun_timer.start(randf_range(1.0, 2.0))


func _on_stun_timer_timeout() -> void:
	transition.emit("Walk")
