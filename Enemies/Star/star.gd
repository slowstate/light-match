class_name Star
extends Enemy

const STAR: PackedScene = preload("res://Enemies/Star/star.tscn")
const STAR_DEATH_PARTICLES = preload("res://Enemies/Star/VFX/star_death_particles.tscn")
const STAR_SHELL_DEATH_PARTICLES = preload("res://Enemies/Star/VFX/star_shell_death_particles.tscn")

@export var shell_colours: Array[Globals.Colour]
@export var shell_rotation_speed := 0.5

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var shells: Node2D = $Shells
@onready var shell_0: Area2D = $Shells/Shell0
@onready var shell_1: Area2D = $Shells/Shell1
@onready var shell_2: Area2D = $Shells/Shell2
@onready var shell_3: Area2D = $Shells/Shell3
@onready var shell_4: Area2D = $Shells/Shell4

@onready var hit_box: Area2D = $HitBox
@onready var hurt_box: Area2D = $HurtBox
@onready var attack_warning_indicator: AttackWarningIndicator = $AttackWarningIndicator
@onready var stun_indicator: StunIndicator = $StunIndicator


static func create(
	initial_position: Vector2,
	initial_health: int,
	initial_colour: Globals.Colour = Globals.pick_random_colour(),
	initial_shell_colours: Array[Globals.Colour] = []
) -> Star:
	var new_star: Star = STAR.instantiate()
	new_star.global_position = initial_position
	new_star.base_health = initial_health
	new_star.max_health = 1
	new_star.colour = initial_colour
	new_star.shell_colours = initial_shell_colours
	new_star.move_speed = randf_range(150.0, 200.0)
	if new_star.shell_colours.size() != 5:
		new_star.shell_colours.resize(5)
	for shell_number in new_star.shell_colours.size():
		new_star.shell_colours[shell_number] = Globals.pick_random_colour()
	return new_star


func rotate_star(delta: float, new_shell_rotation_speed: float) -> void:
	sprite.rotate(delta * new_shell_rotation_speed)
	collision_shape_2d.rotate(delta * new_shell_rotation_speed)
	shells.rotate(delta * new_shell_rotation_speed)


func get_appendages() -> Array[Appendage]:
	var appendages: Array[Appendage] = []
	for appendage in shells.get_children():
		appendages.append(appendage as Appendage)
	return appendages


func enable_hurtbox(enable: bool) -> void:
	hurt_box.set_collision_layer_value(Globals.CollisionLayer.ENEMIES, enable)
	for shell in get_appendages():
		shell.set_collision_layer_value(Globals.CollisionLayer.ENEMIES, enable)
		shell.set_collision_mask_value(Globals.CollisionLayer.BULLETS, enable)


func enable_attack_warning_indicator(enable: bool) -> void:
	attack_warning_indicator.visible = enable


func enable_stun_indicator(enable: bool) -> void:
	stun_indicator.visible = enable


func set_stun_indicator_percentage_completion(percentage_complete: float) -> void:
	stun_indicator.set_stun_percentage_completion(percentage_complete)


func spawn_death_particles(amplitude: float = 1.0) -> void:
	var death_particles = STAR_DEATH_PARTICLES.instantiate()
	death_particles.global_position = global_position
	death_particles.rotation = (global_position - Globals.player.global_position).angle()
	death_particles.set_sprite_global_rotation(global_rotation - deg_to_rad(90))
	death_particles.set_amplitude(amplitude)
	death_particles.set_colour(colour)
	get_tree().root.add_child(death_particles)

	for appendage in get_appendages():
		appendage.spawn_death_particles()
