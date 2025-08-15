extends GPUParticles2D

@onready var head_particle: GPUParticles2D = $HeadParticle
@onready var left_arm_particle: GPUParticles2D = $LeftArmParticle
@onready var right_arm_particle: GPUParticles2D = $RightArmParticle
@onready var gun_particle: GPUParticles2D = $GunParticle


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if emitting:
		head_particle.emitting = true
		left_arm_particle.emitting = true
		right_arm_particle.emitting = true
		gun_particle.emitting = true


func _on_finished() -> void:
	queue_free()
