extends Node

var camera: Camera2D
var timer: Timer
var shake_strength: float = 0.0
var shake_duration: float = 0.2
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	get_tree().root.add_child.call_deferred(timer)


func _physics_process(delta: float) -> void:
	if camera == null:
		return
	if shake_strength > 0.0:
		shake_strength = lerpf(shake_strength, 0, delta / shake_duration)
		camera.offset = random_offset()


func shake(duration: float = 0.2, strength: float = 20.0) -> void:
	camera = get_viewport().get_camera_2d()
	shake_duration = duration
	shake_strength = strength


func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
