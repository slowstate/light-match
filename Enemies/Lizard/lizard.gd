class_name Lizard
extends Enemy

const LIZARD: PackedScene = preload("res://Enemies/Lizard/lizard.tscn")
const LIZARD_DEATH_PARTICLES = preload("res://Enemies/Lizard/VFX/lizard_death_particles.tscn")

@export var head_colour: Globals.Colour = Globals.Colour.BLUE

@onready var head: Area2D = $Head
@onready var hurt_box: Area2D = $HurtBox
@onready var attack_warning_indicator: AttackWarningIndicator = $AttackWarningIndicator
@onready var attack_area_indicator: Sprite2D = $AttackAreaIndicator
@onready var stun_indicator: StunIndicator = $StunIndicator


static func create(
	initial_position: Vector2,
	initial_health: int,
	initial_colour: Globals.Colour = Globals.pick_random_colour(),
	initial_head_colour: Globals.Colour = Globals.pick_random_colour()
) -> Lizard:
	var new_lizard: Lizard = LIZARD.instantiate()
	new_lizard.colour = initial_colour
	new_lizard.base_health = initial_health
	new_lizard.max_health = 4
	new_lizard.head_colour = initial_head_colour
	new_lizard.global_position = initial_position
	new_lizard.move_speed = randf_range(150.0, 200.0)
	return new_lizard


func _setup() -> void:
	head.set_colour(head_colour)
	enable_attack_area_indicator(false)


func get_appendages() -> Array[Appendage]:
	if head == null:
		return []
	return [head]


func enable_hurtbox(enable: bool) -> void:
	hurt_box.set_collision_layer_value(Globals.CollisionLayer.ENEMIES, enable)
	head.set_collision_layer_value(Globals.CollisionLayer.ENEMIES, enable)


func enable_attack_warning_indicator(enable: bool) -> void:
	attack_warning_indicator.visible = enable


func enable_attack_area_indicator(enable: bool) -> void:
	attack_area_indicator.visible = enable


func enable_stun_indicator(enable: bool) -> void:
	stun_indicator.visible = enable


func set_stun_indicator_percentage_completion(percentage_complete: float) -> void:
	stun_indicator.set_stun_percentage_completion(percentage_complete)


func play_move_animation(play: bool) -> void:
	sprite.play_move_animation(play)


func play_attack_animation() -> void:
	if head != null:
		head.play_attack_animation()


func spawn_death_particles(amplitude: float = 1.0) -> void:
	var death_particles = LIZARD_DEATH_PARTICLES.instantiate()
	death_particles.global_position = global_position
	death_particles.rotation = (global_position - Globals.player.global_position).angle()
	death_particles.set_sprite_global_rotation(global_rotation - deg_to_rad(90))
	death_particles.set_amplitude(amplitude)
	death_particles.set_colour(colour)
	get_tree().root.add_child(death_particles)

	if head != null:
		head.spawn_death_particles()
