class_name BotDeathParticles
extends GPUParticles2D

var sprite_global_rotation: float
var amplitude: float = 1.0
var colour: Globals.Colour = Globals.Colour.BLUE

@onready var coloured_particles: GPUParticles2D = $ColouredParticles
@onready var left_arm_particle: GPUParticles2D = $LeftArmParticle
@onready var right_arm_particle: GPUParticles2D = $RightArmParticle
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var flash: Sprite2D = $Flash


func _ready() -> void:
	var proc_mat = process_material as ParticleProcessMaterial
	proc_mat.initial_velocity_min = 50.0
	proc_mat.initial_velocity_max = 200.0 * amplitude
	proc_mat.damping_min = 300.0 * amplitude
	proc_mat.damping_max = 300.0 * amplitude
	amount = 50.0 * amplitude
	coloured_particles.modulate = Globals.COLOUR_VISUAL_VALUE[colour]

	var coloured_proc_mat = coloured_particles.process_material as ParticleProcessMaterial
	coloured_proc_mat.initial_velocity_min = 50.0
	coloured_proc_mat.initial_velocity_max = 200.0 * amplitude
	coloured_proc_mat.damping_min = 300.0 * amplitude
	coloured_proc_mat.damping_max = 300.0 * amplitude
	coloured_particles.amount = 20.0 * amplitude

	flash.scale *= amplitude

	sprite_2d.global_rotation = sprite_global_rotation
	sprite_2d.visible = true
	flash.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	flash.visible = true
	emitting = true
	coloured_particles.emitting = true
	left_arm_particle.emitting = true
	right_arm_particle.emitting = true


func set_amplitude(new_amplitude: float = 1.0) -> void:
	amplitude = new_amplitude


func set_sprite_global_rotation(global_rotation: float) -> void:
	sprite_global_rotation = global_rotation


func set_colour(new_colour: Globals.Colour) -> void:
	colour = new_colour


func _physics_process(delta: float) -> void:
	if emitting:
		sprite_2d.modulate.a = lerp(sprite_2d.modulate.a, 0.0, 15.0 * delta)
		flash.modulate.a = lerp(flash.modulate.a, 0.0, 15.0 * delta)


func _on_finished() -> void:
	queue_free()
