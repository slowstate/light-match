class_name LizardStateChasing
extends State

var lizard: Lizard

func enter() -> void:
	lizard = owner as Lizard
	assert(lizard != null, "The state type must be used only in the Lizard scene. It needs the owner to be a Lizard node.")
	
func exit() -> void:
	pass
	
func update(_delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	if !lizard: return
	if !Globals.player: return
	
	lizard.direction = (Globals.player.global_position - lizard.global_position).normalized()
	var velocity = lizard.direction * lizard.MOVE_SPEED
	lizard.translate(velocity * delta)
	
