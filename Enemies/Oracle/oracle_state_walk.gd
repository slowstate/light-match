class_name OracleStateWalk
extends State

var oracle: Oracle


func enter() -> void:
	oracle = owner as Oracle
	assert(oracle != null, "The state type must be used only in the Oracle scene. It needs the owner to be a Oracle node.")


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
		return
	if oracle.player_is_within_distance(200.0):
		transition.emit("Attack")
		return

	oracle.rotate_orbs(delta, oracle.orb_rotation_speed)
	oracle.move_forward(delta)
