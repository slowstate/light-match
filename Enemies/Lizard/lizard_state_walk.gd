class_name LizardStateWalk
extends State

var lizard: Lizard
var player_detection_distance := randf_range(280.0, 320.0)
var move_speed := randf_range(100.0, 150.0)


func enter() -> void:
	lizard = owner as Lizard
	assert(lizard != null, "The state type must be used only in the Lizard scene. It needs the owner to be a Lizard node.")

	lizard.enable_attack_warning_indicator(false)
	lizard.enable_attack_area_indicator(false)
	lizard.enable_stun_indicator(false)


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !lizard:
		return
	if !Globals.player:
		return

	if lizard.is_stunned():
		lizard.set_stun_indicator_percentage_completion(1 - lizard.stunned_timer.time_left / lizard.stunned_timer.wait_time)
		lizard.enable_stun_indicator(true)
		lizard.dim_lights(ease(1 - lizard.stunned_timer.time_left / lizard.stunned_timer.wait_time, 0.2) * 0.5)
		return
	lizard.enable_stun_indicator(false)
	lizard.dim_lights(0.0)

	if lizard.get_appendages().is_empty():
		transition.emit("AggroDash")
		return
	if lizard.player_is_within_distance(player_detection_distance):
		transition.emit("ShortDash")
		return

	lizard.move_forward(delta, Globals.player.global_position, move_speed)
