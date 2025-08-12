class_name Tank
extends Enemy

const TANK: PackedScene = preload("res://Enemies/Tank/tank.tscn")
const TANK_DEATH_PARTICLES = preload("res://Enemies/Tank/VFX/tank_death_particles.tscn")

@onready var hurt_box: Area2D = $HurtBox
@onready var shield: Area2D = $Shield
@onready var stun_indicator: StunIndicator = $StunIndicator


static func create(initial_position: Vector2, initial_health: int, initial_colour: Globals.Colour = Globals.pick_random_colour()) -> Tank:
	var new_tank: Tank = TANK.instantiate()
	new_tank.global_position = initial_position
	new_tank.base_health = initial_health
	new_tank.max_health = 5
	new_tank.colour = initial_colour
	new_tank.move_speed = randf_range(100.0, 125.0)
	return new_tank


func enable_hurtbox(enable: bool) -> void:
	hurt_box.set_collision_layer_value(Globals.CollisionLayer.ENEMIES, enable)
	shield.set_collision_layer_value(Globals.CollisionLayer.TANK_SHIELD, enable)
	shield.set_collision_mask_value(Globals.CollisionLayer.BULLETS, enable)


func enable_stun_indicator(enable: bool) -> void:
	stun_indicator.visible = enable


func set_stun_indicator_percentage_completion(percentage_complete: float) -> void:
	stun_indicator.set_stun_percentage_completion(percentage_complete)


func spawn_death_particles(amplitude: float = 1.0) -> void:
	var death_particles = TANK_DEATH_PARTICLES.instantiate()
	death_particles.global_position = global_position
	death_particles.rotation = (global_position - Globals.player.global_position).angle()
	death_particles.set_sprite_global_rotation(global_rotation - deg_to_rad(90))
	death_particles.set_amplitude(amplitude)
	death_particles.set_colour(colour)
	get_tree().root.add_child(death_particles)
