class_name BotDeathParticles
extends GPUParticles2D

var sprite_global_rotation: float

@onready var body_particles: GPUParticles2D = $BodyParticles
@onready var left_arm_particle: GPUParticles2D = $LeftArmParticle
@onready var right_arm_particle: GPUParticles2D = $RightArmParticle
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	sprite_2d.global_rotation = sprite_global_rotation
	sprite_2d.visible = true


func set_sprite_global_rotation(global_rotation: float) -> void:
	sprite_global_rotation = global_rotation


func _physics_process(delta: float) -> void:
	if emitting:
		body_particles.emitting = true
		left_arm_particle.emitting = true
		right_arm_particle.emitting = true
		sprite_2d.modulate.a = lerp(sprite_2d.modulate.a, 0.0, 15.0 * delta)


func _on_finished() -> void:
	queue_free()
