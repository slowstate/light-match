class_name Enemy
extends RigidBody2D

@export var colour: Globals.Colour = Globals.Colour.BLUE
@export var health := 1
@export var damage := 1
@export var move_speed := 300.0
@export var sprite: EnemySprite

var can_move: bool = true
var knocked_back: bool = false
var knock_back_position: Vector2
var knock_back_distance: float
var knock_back_speed: float = 300.0

@onready var move_timer: Timer


# This function should be overriden by inheriting classes; no code should be added to this class
static func create(_initial_position: Vector2, _initial_health: int, _initial_colour: Globals.Colour = Globals.pick_random_colour()) -> Enemy:
	return null


func _ready() -> void:
	set_collision_layer_value(Globals.CollisionLayer.ENEMY_SOCIAL_DISTANCING, true)
	set_collision_layer_value(Globals.CollisionLayer.CHROME_KNUCKLES, true)
	set_collision_mask_value(Globals.CollisionLayer.BOUNDARIES, true)
	set_collision_mask_value(Globals.CollisionLayer.ENEMY_SOCIAL_DISTANCING, true)
	gravity_scale = 0
	move_timer = Timer.new()
	move_timer.one_shot = true
	add_child(move_timer)

	sprite.set_health(health)
	set_colour(colour)
	UpgradeManager.on_enemy_spawned(self)
	_setup()


func _physics_process(delta: float) -> void:
	if player_is_within_distance(100.0):
		play_attack_animation()
	move_forward(delta)
	_update(delta)


# This function should be overriden by inheriting classes; no code should be added to this class
func _setup() -> void:
	# Keep this empty as child nodes will override this function
	pass


func _update(_delta: float) -> void:
	pass


func set_colour(new_colour: Globals.Colour) -> void:
	colour = new_colour
	sprite.set_colour(new_colour)


func move_forward(_delta: float) -> void:
	if !can_move:
		return
	play_move_animation(true)
	rotation = (Globals.player.global_position - global_position).angle()
	var distance_based_move_speed = move_speed * lerp(1.2, 0.3, clamp((global_position - Globals.player.global_position).length() / 2000.0, 0.0, 1.0))
	if move_timer.is_stopped():
		linear_velocity = (Globals.player.global_position - global_position).normalized() * distance_based_move_speed
		apply_force(linear_velocity)


func knock_back(force: float, duration_in_seconds: float) -> void:
	move_timer.start(duration_in_seconds)
	linear_velocity = Vector2(0, 0)
	apply_impulse((global_position - Globals.player.global_position).normalized() * force)


func player_is_within_distance(distance := 500.0) -> bool:
	return (global_position - Globals.player.global_position).length() < distance


func get_appendages() -> Array[Appendage]:
	return []


func _on_area_entered(area: Area2D) -> void:
	var bullet = area as Bullet
	if bullet == null:
		return
	UpgradeManager.on_enemy_hit(bullet, self)

	var log_context_data = {
		"enemy": get_script().get_global_name() + str(get_instance_id()), "bullet": bullet.get_script().get_global_name() + str(bullet.get_instance_id())
	}
	var log_play_data = {}

	if bullet.colour != colour:
		SfxManager.play_sound("EnemyDeflectSFX", -5.0, -3.0, 0.95, 1.05)

		log_play_data = {"message": "Enemy hit with wrong colour", "context": log_context_data}
		Logger.log_play_data(log_play_data)
		return

	health -= bullet.damage
	SfxManager.play_sound("EnemyHitSFX", -20.0, -18.0, 1, 1.2)
	sprite.set_health(health)

	log_play_data = {"message": "Enemy hit for " + str(bullet.damage) + " damage", "context": log_context_data}
	Logger.log_play_data(log_play_data)

	if health <= 0:
		log_play_data = {"message": "Enemy killed", "context": log_context_data}
		UpgradeManager.on_enemy_killed(self)
		SignalBus.emit_signal("enemy_died", self)
		Logger.log_play_data(log_play_data)
		queue_free()


func play_move_animation(_play: bool) -> void:
	pass


func play_attack_animation() -> void:
	pass
