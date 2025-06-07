class_name TankStateChasing
extends State

var tank: Tank


func enter() -> void:
	tank = owner as Tank
	assert(tank != null, "The state type must be used only in the Tank scene. It needs the owner to be a Tank node.")


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !tank:
		return
	if !Globals.player:
		return

	var direction_to_player = (Globals.player.global_position - tank.global_position).normalized().angle()
	tank.desired_rotation = direction_to_player
	tank.move_forward(delta)
