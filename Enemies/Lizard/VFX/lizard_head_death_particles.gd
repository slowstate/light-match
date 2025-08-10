extends GPUParticles2D

var angle: float = 0.0


func _ready() -> void:
	var proc_mat = process_material as ParticleProcessMaterial
	var direction = Vector2.from_angle((global_position - Globals.player.global_position).angle())
	proc_mat.direction = Vector3(direction.x, direction.y, 0)
	proc_mat.angle_max = angle
	proc_mat.angle_min = angle
	emitting = true


func set_angle(angle_in_degrees: float) -> void:
	angle = angle_in_degrees


func _on_finished() -> void:
	queue_free()
