class_name Oracle
extends Enemy

const ORACLE: PackedScene = preload("res://Enemies/Oracle/oracle.tscn")
const ORACLE_DEATH_PARTICLES = preload("res://Enemies/Oracle/VFX/oracle_death_particles.tscn")
const ORACLE_ORB_DEATH_PARTICLES = preload("res://Enemies/Oracle/VFX/oracle_orb_death_particles.tscn")

@onready var hurt_box: Area2D = $HurtBox
@onready var attack_warning_indicator: AttackWarningIndicator = $AttackWarningIndicator
@onready var stun_indicator: StunIndicator = $StunIndicator

@export var orb_colour: Globals.Colour = Globals.Colour.BLUE
@export var orb_rotation_speed := 1.0

@onready var orbs: Node2D = $Orbs
@onready var orb_0: Area2D = $Orbs/Orb0
@onready var orb_1: Area2D = $Orbs/Orb1
@onready var orb_2: Area2D = $Orbs/Orb2
@onready var orb_3: Area2D = $Orbs/Orb3
@onready var orb_4: Area2D = $Orbs/Orb4
@onready var orb_5: Area2D = $Orbs/Orb5


static func create(
	initial_position: Vector2,
	initial_health: int,
	initial_colour: Globals.Colour = Globals.pick_random_colour(),
	initial_orb_colour: Globals.Colour = Globals.pick_random_colour()
) -> Oracle:
	var new_oracle: Oracle = ORACLE.instantiate()
	new_oracle.global_position = initial_position
	new_oracle.base_health = initial_health
	new_oracle.max_health = 3
	new_oracle.colour = initial_colour
	new_oracle.orb_colour = initial_orb_colour
	new_oracle.move_speed = randf_range(250.0, 300.0)
	return new_oracle


func rotate_orbs(delta: float, new_orb_rotation_speed: float) -> void:
	orbs.rotate(delta * new_orb_rotation_speed)


func get_appendages() -> Array[Appendage]:
	var appendages: Array[Appendage] = []
	for appendage in orbs.get_children():
		appendages.append(appendage as Appendage)
	return appendages


func enable_hurtbox(enable: bool) -> void:
	hurt_box.set_collision_layer_value(Globals.CollisionLayer.ENEMIES, enable)
	for orb in get_appendages():
		orb.set_collision_layer_value(Globals.CollisionLayer.ENEMIES, enable)
		orb.set_collision_mask_value(Globals.CollisionLayer.BULLETS, enable)


func enable_attack_warning_indicator(enable: bool) -> void:
	attack_warning_indicator.visible = enable


func enable_stun_indicator(enable: bool) -> void:
	stun_indicator.visible = enable


func set_stun_indicator_percentage_completion(percentage_complete: float) -> void:
	stun_indicator.set_stun_percentage_completion(percentage_complete)


func spawn_death_particles(amplitude: float = 1.0) -> void:
	var death_particles = ORACLE_DEATH_PARTICLES.instantiate()
	death_particles.global_position = global_position
	death_particles.rotation = (global_position - Globals.player.global_position).angle()
	death_particles.set_sprite_global_rotation(global_rotation - deg_to_rad(90))
	death_particles.set_amplitude(amplitude)
	death_particles.set_colour(colour)
	get_tree().root.add_child(death_particles)

	for appendage in get_appendages():
		var orb_death_particles = ORACLE_ORB_DEATH_PARTICLES.instantiate()
		orb_death_particles.global_position = appendage.global_position
		orb_death_particles.set_colour(appendage.colour)
		get_tree().root.add_child(orb_death_particles)
