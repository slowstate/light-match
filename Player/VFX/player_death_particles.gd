extends GPUParticles2D

@onready var head_particle: GPUParticles2D = $HeadParticle
@onready var left_arm_particle: GPUParticles2D = $LeftArmParticle
@onready var right_arm_particle: GPUParticles2D = $RightArmParticle
@onready var gun_particle: GPUParticles2D = $GunParticle
@onready var gun_particle_2: GPUParticles2D = $GunParticle2
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var gpu_particles_2d_2: GPUParticles2D = $GPUParticles2D2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if emitting:
		head_particle.emitting = true
		left_arm_particle.emitting = true
		right_arm_particle.emitting = true
		gun_particle.emitting = true
		gun_particle_2.emitting = true
		gpu_particles_2d.emitting = true
		gpu_particles_2d_2.emitting = true


func _on_finished() -> void:
	queue_free()
