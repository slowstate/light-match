class_name LizardStateAggroDash
extends State

var lizard: Lizard
var target_location: Vector2
var dashing: bool = false

@onready var stun_timer: Timer = $StunTimer
@onready var charge_timer: Timer = $ChargeTimer
@onready var timer: Timer = $Timer


func enter() -> void:
	lizard = owner as Lizard
	assert(lizard != null, "The state type must be used only in the Lizard scene. It needs the owner to be a Lizard node.")
	dashing = false
	lizard.sleeping = true
	if !stun_timer.timeout.is_connected(_on_stun_timer_timeout):
		stun_timer.timeout.connect(_on_stun_timer_timeout)
	if !charge_timer.timeout.is_connected(_on_charge_timer_timeout):
		charge_timer.timeout.connect(_on_charge_timer_timeout)
	if !timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	stun_timer.start(randf_range(3.0, 4.0))


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !charge_timer.is_stopped():
		lizard.rotation = lerp_angle(lizard.rotation, (target_location - lizard.global_position).angle(), 3.0 * delta)
	if dashing:
		lizard.global_position = lizard.global_position.lerp(target_location, 5.0 * delta).clamp(Vector2(30, 30), Vector2(3810, 2130))


func _on_stun_timer_timeout() -> void:
	target_location = lizard.global_position + (Globals.player.global_position - lizard.global_position).normalized() * randf_range(600.0, 700.0)
	charge_timer.start(randf_range(1.0, 1.5))


func _on_charge_timer_timeout() -> void:
	dashing = true
	timer.start(0.5)


func _on_timer_timeout() -> void:
	dashing = false
	stun_timer.start(randf_range(1.0, 1.5))
