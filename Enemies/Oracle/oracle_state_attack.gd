class_name OracleStateAttack
extends State

var oracle: Oracle
var attack_rotation_speed: float
var expand_time: float = 2.0
var spin_up_time: float = 2.0
var spin_down_time: float = 2.0
var shrink_time: float = 2.0

@onready var expand_timer: Timer = $ExpandTimer
@onready var spin_up_timer: Timer = $SpinUpTimer
@onready var spin_down_timer: Timer = $SpinDownTimer
@onready var shrink_timer: Timer = $ShrinkTimer


func enter() -> void:
	oracle = owner as Oracle
	assert(oracle != null, "The state type must be used only in the Oracle scene. It needs the owner to be a Oracle node.")

	oracle.enable_attack_warning_indicator(true)

	attack_rotation_speed = oracle.orb_rotation_speed
	oracle.sleeping = true
	if !expand_timer.timeout.is_connected(_on_expand_timer_timeout):
		expand_timer.timeout.connect(_on_expand_timer_timeout)
	if !spin_up_timer.timeout.is_connected(_on_spin_up_timer_timeout):
		spin_up_timer.timeout.connect(_on_spin_up_timer_timeout)
	if !spin_down_timer.timeout.is_connected(_on_spin_down_timer_timeout):
		spin_down_timer.timeout.connect(_on_spin_down_timer_timeout)
	if !shrink_timer.timeout.is_connected(_on_shrink_timer_timeout):
		shrink_timer.timeout.connect(_on_shrink_timer_timeout)
	expand_timer.start(expand_time)
	SfxManager.play_sound("OracleAttackSFX", -30.0, -28.0, 0.9, 1.0)


func exit() -> void:
	for orb in oracle.orbs.get_children():
		orb = orb as Appendage
		orb.position = orb.original_position
		orb.scale = Vector2(1.0, 1.0)


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !oracle:
		return
	if !Globals.player:
		return

	if oracle.is_stunned():
		oracle.set_stun_indicator_percentage_completion(1 - oracle.stunned_timer.time_left / oracle.stunned_timer.wait_time)
		oracle.enable_attack_warning_indicator(false)
		oracle.enable_stun_indicator(true)
		oracle.dim_lights(ease(1 - oracle.stunned_timer.time_left / oracle.stunned_timer.wait_time, 0.2) * 0.5)
		expand_timer.paused = true
		shrink_timer.paused = true
		spin_up_timer.paused = true
		spin_down_timer.paused = true
		return
	oracle.enable_stun_indicator(false)
	oracle.enable_attack_warning_indicator(true)
	oracle.dim_lights(clampf(oracle.get_dim_lights_amount() - delta * 2.0, 0.0, 1.0))
	expand_timer.paused = false
	shrink_timer.paused = false
	spin_up_timer.paused = false
	spin_down_timer.paused = false

	if !expand_timer.is_stopped():
		for orb in oracle.orbs.get_children():
			orb = orb as Appendage
			orb.position = orb.position.lerp(orb.original_position * 5, ease(1 - expand_timer.time_left / expand_timer.wait_time, 2.0))
			orb.scale = orb.scale.lerp(Vector2(2.0, 2.0), ease(1 - expand_timer.time_left / expand_timer.wait_time, 2.0))
	elif !shrink_timer.is_stopped():
		for orb in oracle.orbs.get_children():
			orb = orb as Appendage
			orb.position = orb.position.lerp(orb.original_position, ease(1 - shrink_timer.time_left / shrink_timer.wait_time, 2.0))
			orb.scale = orb.scale.lerp(Vector2(1.0, 1.0), ease(1 - shrink_timer.time_left / shrink_timer.wait_time, 2.0))

	if !spin_up_timer.is_stopped():
		attack_rotation_speed = lerpf(
			oracle.orb_rotation_speed, oracle.orb_rotation_speed * 4.0, ease(1 - spin_up_timer.time_left / spin_up_timer.wait_time, 2.0)
		)
	elif !spin_down_timer.is_stopped():
		attack_rotation_speed = lerpf(
			oracle.orb_rotation_speed * 4.0, oracle.orb_rotation_speed, ease(1 - spin_down_timer.time_left / spin_down_timer.wait_time, 1.0)
		)
	else:
		attack_rotation_speed = oracle.orb_rotation_speed
	oracle.rotate_orbs(delta, attack_rotation_speed)


func _on_expand_timer_timeout() -> void:
	spin_up_timer.start(spin_up_time)


func _on_spin_up_timer_timeout() -> void:
	spin_down_timer.start(spin_down_time)


func _on_spin_down_timer_timeout() -> void:
	shrink_timer.start(shrink_time)


func _on_shrink_timer_timeout() -> void:
	transition.emit("Walk")
