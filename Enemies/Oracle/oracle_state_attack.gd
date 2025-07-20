class_name OracleStateAttack
extends State

var oracle: Oracle
var attack_rotation_speed: float

@onready var expand_timer: Timer = $ExpandTimer
@onready var spin_up_timer: Timer = $SpinUpTimer
@onready var spin_down_timer: Timer = $SpinDownTimer
@onready var shrink_timer: Timer = $ShrinkTimer


func enter() -> void:
	oracle = owner as Oracle
	assert(oracle != null, "The state type must be used only in the Oracle scene. It needs the owner to be a Oracle node.")
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
	expand_timer.start(2.0)


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !oracle:
		return
	if !Globals.player:
		return

	if oracle.player_is_within_distance():
		transition.emit("Chasing")

	if !expand_timer.is_stopped():
		for orb in oracle.orbs.get_children():
			orb = orb as Appendage
			orb.position = orb.position.lerp(orb.original_position * 5, delta)
			orb.scale = orb.scale.lerp(Vector2(2.0, 2.0), delta)
	elif !shrink_timer.is_stopped():
		for orb in oracle.orbs.get_children():
			orb = orb as Appendage
			orb.position = orb.position.lerp(orb.original_position, delta)
			orb.scale = orb.scale.lerp(Vector2(1.0, 1.0), delta)

	if !spin_up_timer.is_stopped():
		attack_rotation_speed = lerpf(attack_rotation_speed, oracle.orb_rotation_speed * 4.0, delta / 2.0)
		oracle.rotate_orbs(delta, attack_rotation_speed)
	elif !spin_down_timer.is_stopped():
		attack_rotation_speed = lerpf(attack_rotation_speed, oracle.orb_rotation_speed, delta / 2.0)
		oracle.rotate_orbs(delta, attack_rotation_speed)
	else:
		oracle.rotate_orbs(delta, oracle.orb_rotation_speed)


func _on_expand_timer_timeout() -> void:
	spin_up_timer.start(3.0)


func _on_spin_up_timer_timeout() -> void:
	spin_down_timer.start(3.0)


func _on_spin_down_timer_timeout() -> void:
	shrink_timer.start(2.0)


func _on_shrink_timer_timeout() -> void:
	transition.emit("Walk")
