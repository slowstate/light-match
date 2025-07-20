class_name LizardStateWalk
extends State

var lizard: Lizard
var player_detection_distance := randf_range(280.0, 320.0)
var move_speed := randf_range(180.0, 220.0)


func enter() -> void:
	lizard = owner as Lizard
	assert(lizard != null, "The state type must be used only in the Lizard scene. It needs the owner to be a Lizard node.")


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !lizard:
		return
	if !Globals.player:
		return

	if lizard.get_appendages().is_empty():
		transition.emit("AggroDash")
		return
	if lizard.player_is_within_distance(player_detection_distance):
		transition.emit("ShortDash")
		return

	lizard.move_forward(delta, Globals.player.global_position, move_speed)
