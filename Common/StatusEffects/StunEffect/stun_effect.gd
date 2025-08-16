class_name StunEffect
extends Node

var effect_duration: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_parent()
	if parent is not Enemy:
		return
	ConditionManager.on_enemy_pre_stunned(parent, self)
	if effect_duration <= 0.0:
		queue_free()
		return
	parent.stun(effect_duration)
	ConditionManager.on_enemy_stunned(parent)
	#SfxManager.play_sound("EnemyStunnedSFX", -20.0, -18.0, 0.9, 1.0)
