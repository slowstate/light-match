class_name PaletteColour
extends Control

@onready var palette_colour_sprite: Sprite2D = $PaletteColourSprite


func update_shader_rand(random_number: float) -> void:
	palette_colour_sprite.material.set_shader_parameter("random_number", random_number)


func update_shader_timer_progress(timer_progress: float) -> void:
	palette_colour_sprite.material.set_shader_parameter("timer_progress", timer_progress)


func get_shader_modulate() -> Color:
	return palette_colour_sprite.material.get_shader_parameter("modulation")


func update_shader_modulate(modulation: Color) -> void:
	palette_colour_sprite.material.set_shader_parameter("modulation", modulation)


func update_shader_alpha(alpha: float) -> void:
	palette_colour_sprite.material.set_shader_parameter("alpha", alpha)
