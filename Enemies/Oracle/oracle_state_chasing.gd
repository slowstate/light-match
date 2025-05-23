class_name OracleStateChasing
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

	var direction_to_player = (Globals.player.global_position - oracle.global_position).normalized().angle()
	oracle.desired_rotation = direction_to_player
	oracle.move_forward(delta)
