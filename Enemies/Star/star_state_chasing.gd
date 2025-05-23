class_name StarStateChasing
extends State

var star: Star


func enter() -> void:
	star = owner as Star
	assert(star != null, "The state type must be used only in the Star scene. It needs the owner to be a Star node.")


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !star:
		return
	if !Globals.player:
		return

	var direction_to_player = (Globals.player.global_position - star.global_position).normalized().angle()
	star.desired_rotation = direction_to_player
	star.move_forward(delta)
