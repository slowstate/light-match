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

	lizard.attack_area_indicator.scale.x = 0
	lizard.attack_area_indicator.modulate.a = 0
	lizard.enable_attack_warning_indicator(true)
	lizard.enable_attack_area_indicator(true)
	lizard.enable_stun_indicator(false)

	lizard.sleeping = true
	target_location = lizard.global_position + (Globals.player.global_position - lizard.global_position).normalized() * randf_range(350.0, 450.0)
	var texture = lizard.attack_area_indicator.texture as GradientTexture2D
	texture.width = (target_location - lizard.global_position).length()
	if !charge_timer.timeout.is_connected(_on_charge_timer_timeout):
		charge_timer.timeout.connect(_on_charge_timer_timeout)
	if !dash_timer.timeout.is_connected(_on_dash_timer_timeout):
		dash_timer.timeout.connect(_on_dash_timer_timeout)
	if !stun_timer.timeout.is_connected(_on_stun_timer_timeout):
		stun_timer.timeout.connect(_on_stun_timer_timeout)
	charge_timer.start(0.5)


func exit() -> void:
	charge_timer.stop()
	dash_timer.stop()
	stun_timer.stop()


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if lizard.is_stunned():
		transition.emit("Walk")
		stun_timer.stop()
		charge_timer.stop()
		dash_timer.stop()
		return

	if lizard.get_appendages().is_empty():
		transition.emit("AggroDash")
		return

	if !charge_timer.is_stopped():
		lizard.rotation = lerp_angle(
			lizard.rotation, (target_location - lizard.global_position).angle(), ease(1 - charge_timer.time_left / charge_timer.wait_time, -2.0)
		)
		lizard.attack_area_indicator.scale.x = lerpf(0.0, 1.0, ease(1 - charge_timer.time_left / charge_timer.wait_time, 0.5))
		lizard.attack_area_indicator.modulate.a = lerpf(0.0, 1.0, ease(1 - charge_timer.time_left / charge_timer.wait_time, 0.5))
		lizard.attack_area_indicator.modulate.g = lerpf(1.0, 0.0, ease(1 - charge_timer.time_left / charge_timer.wait_time, 1.0))
	if !dash_timer.is_stopped():
		lizard.global_position = lizard.global_position.lerp(target_location, ease(1 - dash_timer.time_left / dash_timer.wait_time, -2.0))
		lizard.global_position = lizard.global_position.clamp(Vector2(65, 65), Vector2(2495, 1385))

	if !stun_timer.is_stopped():
		lizard.set_stun_indicator_percentage_completion(1 - stun_timer.time_left / stun_timer.wait_time)
		lizard.dim_lights(ease(1 - stun_timer.time_left / stun_timer.wait_time, 0.2) * 0.5)


func _on_charge_timer_timeout() -> void:
	lizard.enable_attack_area_indicator(false)
	lizard.play_attack_animation()
	dash_timer.start(dash_time)


func _on_dash_timer_timeout() -> void:
	lizard.enable_attack_warning_indicator(false)
	lizard.enable_stun_indicator(true)
	stun_timer.start(2.0)


func _on_stun_timer_timeout() -> void:
	lizard.dim_lights(0.0)
	transition.emit("Walk")
