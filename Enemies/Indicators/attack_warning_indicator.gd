class_name AttackWarningIndicator
extends Sprite2D

@export var custom_offset: Vector2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	global_position = get_parent().global_position + custom_offset
