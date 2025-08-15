extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var proc_mat = process_material as ParticleProcessMaterial
	proc_mat.angle_min = -rad_to_deg((get_global_mouse_position() - global_position).angle()) - 90
	proc_mat.angle_max = -rad_to_deg((get_global_mouse_position() - global_position).angle()) - 90


func _on_finished() -> void:
	queue_free()
