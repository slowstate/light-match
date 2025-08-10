class_name OracleStateWalk
extends State

var oracle: Oracle


func enter() -> void:
	oracle = owner as Oracle
	assert(oracle != null, "The state type must be used only in the Oracle scene. It needs the owner to be a Oracle node.")

	oracle.enable_attack_warning_indicator(false)


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !oracle:
		return
	if !Globals.player:
		return
	if oracle.is_stunned():
		oracle.set_stun_indicator_percentage_completion(1 - oracle.stunned_timer.time_left / oracle.stunned_timer.wait_time)
		oracle.enable_stun_indicator(true)
		oracle.dim_lights(ease(1 - oracle.stunned_timer.time_left / oracle.stunned_timer.wait_time, 0.2) * 0.5)
		return
	oracle.enable_stun_indicator(false)
	oracle.dim_lights(clampf(oracle.get_dim_lights_amount() - delta * 2.0, 0.0, 1.0))

	if oracle.player_is_within_distance(200.0):
		transition.emit("Attack")
		return

	oracle.rotate_orbs(delta, oracle.orb_rotation_speed)
	oracle.move_forward(delta)
