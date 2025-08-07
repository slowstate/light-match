class_name BotDeathParticles
extends GPUParticles2D

var sprite_global_rotation: float

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var gpu_particles_2d_2: GPUParticles2D = $GPUParticles2D2
@onready var gpu_particles_2d_3: GPUParticles2D = $GPUParticles2D3
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	sprite_2d.global_rotation = sprite_global_rotation
	sprite_2d.visible = true


func set_sprite_global_rotation(global_rotation: float) -> void:
	sprite_global_rotation = global_rotation


func _physics_process(delta: float) -> void:
	if emitting:
		gpu_particles_2d.emitting = true
		gpu_particles_2d_2.emitting = true
		gpu_particles_2d_3.emitting = true
		sprite_2d.modulate.a = lerp(sprite_2d.modulate.a, 0.0, 15.0 * delta)


func _on_finished() -> void:
	queue_free()
