class_name Bot
extends Enemy

const BOT: PackedScene = preload("res://Enemies/Bot/bot.tscn")
const BOT_DEATH_PARTICLES = preload("res://Enemies/Bot/VFX/bot_death_particles.tscn")

@onready var hurt_box: Area2D = $HurtBox
@onready var attack_warning_indicator: AttackWarningIndicator = $AttackWarningIndicator
@onready var stun_indicator: StunIndicator = $StunIndicator


static func create(initial_position: Vector2, initial_health: int, initial_colour: Globals.Colour = Globals.pick_random_colour()) -> Bot:
	var new_bot: Bot = BOT.instantiate()
	new_bot.global_position = initial_position
	new_bot.base_health = initial_health
	new_bot.max_health = 3
	new_bot.colour = initial_colour
	new_bot.move_speed = 100.0
	return new_bot


func enable_hurtbox(enable: bool) -> void:
	hurt_box.set_collision_layer_value(Globals.CollisionLayer.ENEMIES, enable)


func enable_attack_warning_indicator(enable: bool) -> void:
	attack_warning_indicator.visible = enable


func enable_stun_indicator(enable: bool) -> void:
	stun_indicator.visible = enable


func set_stun_indicator_percentage_completion(percentage_complete: float) -> void:
	stun_indicator.set_stun_percentage_completion(percentage_complete)


func play_move_animation(play: bool) -> void:
	sprite.play_move_animation(play)


func play_attack_animation() -> void:
	sprite.play_attack_animation()


func spawn_death_particles() -> void:
	var death_particles = BOT_DEATH_PARTICLES.instantiate()
	death_particles.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	death_particles.global_position = global_position
	death_particles.rotation = (global_position - Globals.player.global_position).angle()
	death_particles.set_sprite_global_rotation(global_rotation - deg_to_rad(90))
	death_particles.emitting = true
	get_tree().root.add_child(death_particles)
