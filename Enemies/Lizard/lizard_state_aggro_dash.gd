class_name LizardStateAggroDash
extends State

var lizard: Lizard
var target_location: Vector2

@onready var stun_timer: Timer = $StunTimer
@onready var charge_timer: Timer = $ChargeTimer
@onready var dash_timer: Timer = $DashTimer


func enter() -> void:
	lizard = owner as Lizard
	assert(lizard != null, "The state type must be used only in the Lizard scene. It needs the owner to be a Lizard node.")
	lizard.sleeping = true
	if !stun_timer.timeout.is_connected(_on_stun_timer_timeout):
		stun_timer.timeout.connect(_on_stun_timer_timeout)
	if !charge_timer.timeout.is_connected(_on_charge_timer_timeout):
		charge_timer.timeout.connect(_on_charge_timer_timeout)
	if !dash_timer.timeout.is_connected(_on_dash_timer_timeout):
		dash_timer.timeout.connect(_on_dash_timer_timeout)
	stun_timer.start(randf_range(3.0, 4.0))


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !charge_timer.is_stopped():
		lizard.rotation = lerp_angle(
			lizard.rotation, (target_location - lizard.global_position).angle(), ease(1 - charge_timer.time_left / charge_timer.wait_time, -2.0)
		)
	if !dash_timer.is_stopped():
		lizard.global_position = lizard.global_position.lerp(target_location, ease(1 - dash_timer.time_left / dash_timer.wait_time, -2.0))


func _on_stun_timer_timeout() -> void:
	target_location = lizard.global_position + (Globals.player.global_position - lizard.global_position).normalized() * randf_range(700.0, 800.0)
	charge_timer.start(randf_range(0.1, 0.2))


func _on_charge_timer_timeout() -> void:
	dash_timer.start(1.0)


func _on_dash_timer_timeout() -> void:
	stun_timer.start(randf_range(1.0, 1.5))
