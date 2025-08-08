extends Camera2D

var desired_offset: Vector2
var min_offset: float = -200
var max_offset: float = 200


func _physics_process(delta: float) -> void:
	if Globals.player.controls_enabled:
		desired_offset = (get_global_mouse_position() - Globals.player.global_position) * 0.2
		desired_offset.x = clampf(desired_offset.x, min_offset, max_offset)
		desired_offset.y = clampf(desired_offset.y, min_offset, max_offset)
		global_position = Globals.player.global_position + desired_offset
