extends GPUParticles2D

var progress: float = 0.0


func _physics_process(delta: float) -> void:
	progress += delta / 0.2
	global_position = lerp(global_position, Globals.player.global_position, clamp(progress, 0.0, 1.0))


func _on_finished() -> void:
	queue_free()
