class_name LizardStateShortDash
extends State

var lizard: Lizard
var target_location: Vector2
var dash_time: float = 1.0

@onready var charge_timer: Timer = $ChargeTimer
@onready var dash_timer: Timer = $DashTimer
@onready var stun_timer: Timer = $StunTimer


func enter() -> void:
	lizard = owner as Lizard
	assert(lizard != null, "The state type must be used only in the Lizard scene. It needs the owner to be a Lizard node.")
	lizard.sleeping = true
	target_location = lizard.global_position + (Globals.player.global_position - lizard.global_position).normalized() * randf_range(350.0, 450.0)
	if !charge_timer.timeout.is_connected(_on_charge_timer_timeout):
		charge_timer.timeout.connect(_on_charge_timer_timeout)
	if !dash_timer.timeout.is_connected(_on_dash_timer_timeout):
		dash_timer.timeout.connect(_on_dash_timer_timeout)
	if !stun_timer.timeout.is_connected(_on_stun_timer_timeout):
		stun_timer.timeout.connect(_on_stun_timer_timeout)
	charge_timer.start(randf_range(0.1, 0.2))
	lizard.play_attack_animation()


func exit() -> void:
	charge_timer.stop()
	dash_timer.stop()
	stun_timer.stop()


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if lizard.is_stunned():
		stun_timer.paused = true
		charge_timer.paused = true
		dash_timer.paused = true
		return
	stun_timer.paused = false
	charge_timer.paused = false
	dash_timer.paused = false

	if lizard.get_appendages().is_empty():
		transition.emit("AggroDash")
		return

	if !charge_timer.is_stopped():
		lizard.rotation = lerp_angle(
			lizard.rotation, (target_location - lizard.global_position).angle(), ease(1 - charge_timer.time_left / charge_timer.wait_time, -2.0)
		)
	if !dash_timer.is_stopped():
		lizard.global_position = lizard.global_position.lerp(target_location, ease(1 - dash_timer.time_left / dash_timer.wait_time, -2.0))
		lizard.global_position = lizard.global_position.clamp(Vector2(65, 65), Vector2(3775, 2095))
		lizard.rotation = lerp_angle(lizard.rotation, (Globals.player.global_position - lizard.global_position).angle(), 2.0 * delta)
	if !stun_timer.is_stopped():
		lizard.rotation = lerp_angle(lizard.rotation, (Globals.player.global_position - lizard.global_position).angle(), 3.0 * delta)


func _on_charge_timer_timeout() -> void:
	dash_timer.start(dash_time)


func _on_dash_timer_timeout() -> void:
	stun_timer.start(randf_range(1.0, 2.0))


func _on_stun_timer_timeout() -> void:
	transition.emit("Walk")
