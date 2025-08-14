class_name MoveSpeedEffect
extends Node2D

var effect_amount: float = 0.0
var effect_duration: float = 0.0
var effect_timer: Timer

@onready var slow_particles: GPUParticles2D = $SlowParticles


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_parent()
	if parent is not Player and parent is not Enemy:
		return
	if parent is Enemy:
		ConditionManager.on_enemy_pre_slowed(parent, self)
	if effect_amount == 0.0:
		queue_free()
		return
	if effect_amount < 0.0:
		slow_particles.emitting = true
	else:
		slow_particles.emitting = false

	get_parent().move_speed *= 1.0 + effect_amount
	effect_timer = Timer.new()
	effect_timer.one_shot = true
	add_child(effect_timer)
	if !effect_timer.timeout.is_connected(_on_effect_timer_timeout):
		effect_timer.timeout.connect(_on_effect_timer_timeout)
	effect_timer.start(effect_duration)
	if parent is Enemy and effect_amount < 0:
		ConditionManager.on_enemy_slowed(get_parent(), self)


func _on_effect_timer_timeout() -> void:
	get_parent().move_speed /= 1.0 + effect_amount
	queue_free()
