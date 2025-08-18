extends GPUParticles2D

var colour: Globals.Colour = Globals.Colour.BLUE

@onready var coloured_particles: GPUParticles2D = $ColouredParticles
@onready var flash: Sprite2D = $Flash


func _ready() -> void:
	coloured_particles.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	flash.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	flash.visible = true
	emitting = true
	coloured_particles.emitting = true


func set_colour(new_colour: Globals.Colour) -> void:
	colour = new_colour


func _physics_process(delta: float) -> void:
	if emitting:
		flash.modulate.a = lerp(flash.modulate.a, 0.0, 15.0 * delta)


func _on_finished() -> void:
	queue_free()
