class_name BotDeathParticles
extends GPUParticles2D

var sprite_global_rotation: float
var amplitude: float = 1.0

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
	amount = 50 * amplitude

	var body_proc_mat = process_material as ParticleProcessMaterial
	body_proc_mat.initial_velocity_min = 50.0
	body_proc_mat.initial_velocity_max = 200.0 * amplitude
	body_proc_mat.damping_min = 300.0 * amplitude
	body_proc_mat.damping_max = 300.0 * amplitude
	coloured_particles.amount = 20.0 * amplitude

	flash.scale *= amplitude

	sprite_2d.global_rotation = sprite_global_rotation
	sprite_2d.visible = true
	flash.modulate = modulate
	emitting = true
	coloured_particles.emitting = true
	left_arm_particle.emitting = true
	right_arm_particle.emitting = true


func set_amplitude(new_amplitude: float = 1.0) -> void:
	amplitude = new_amplitude


func set_sprite_global_rotation(global_rotation: float) -> void:
	sprite_global_rotation = global_rotation


func _physics_process(delta: float) -> void:
	if emitting:
		sprite_2d.modulate.a = lerp(sprite_2d.modulate.a, 0.0, 15.0 * delta)
		flash.modulate.a = lerp(sprite_2d.modulate.a, 0.0, 15.0 * delta)


func _on_finished() -> void:
	queue_free()
