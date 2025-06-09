class_name PaletteColour
extends Sprite2D


func update_shader_timer_progress(timer_progress: float) -> void:
	material.set_shader_parameter("timer_progress", timer_progress)


func update_shader_modulate(modulation: Color) -> void:
	material.set_shader_parameter("modulation", modulation)
