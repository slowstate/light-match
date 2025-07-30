extends Control


func _ready() -> void:
	visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_cancel"):
		for control_remapper in get_tree().get_nodes_in_group("Control Remappers"):
			control_remapper = control_remapper as ControlRemapper
			if control_remapper.control_remap_button.button_pressed:
				return
		visible = false
