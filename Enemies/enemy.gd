class_name Enemy
extends RigidBody2D

@export var colour: Globals.Colour = Globals.Colour.BLUE
@export var max_health := 1
@export var base_health := 1
@export var health := 1
@export var damage := 1
@export var move_speed := 300.0
@export var sprite: EnemySprite

var knocked_back: bool = false
var knock_back_position: Vector2
var knock_back_distance: float
var knock_back_speed: float = 300.0
var knock_back_timer: Timer
var stunned_timer: Timer
var invulnerable_timer: Timer
var regen_timer: Timer
var health_regen: int = 0


# This function should be overriden by inheriting classes; no code should be added to this class
static func create(_initial_position: Vector2, _initial_health: int, _initial_colour: Globals.Colour = Globals.pick_random_colour()) -> Enemy:
	return null


func _ready() -> void:
	set_collision_layer_value(Globals.CollisionLayer.CHROME_KNUCKLES, true)
	set_collision_mask_value(Globals.CollisionLayer.BOUNDARIES, true)
	gravity_scale = 0
	knock_back_timer = Timer.new()
	knock_back_timer.one_shot = true
	add_child(knock_back_timer)
	stunned_timer = Timer.new()
	stunned_timer.one_shot = true
	add_child(stunned_timer)
	invulnerable_timer = Timer.new()
	invulnerable_timer.one_shot = true
	add_child(invulnerable_timer)
	regen_timer = Timer.new()
	regen_timer.timeout.connect(_on_regen_timer_timeout)
	add_child(regen_timer)

	set_health(base_health)
	set_colour(colour)
	modulate.a = 0
	enable_hurtbox(false)
	enable_attack_warning_indicator(false)
	enable_stun_indicator(false)
	ConditionManager.on_enemy_spawned(self)
	UpgradeManager.on_enemy_spawned(self)
	_setup()


# This function should be overriden by inheriting classes; no code should be added to this class
func _setup() -> void:
	# Keep this empty as child nodes will override this function
	pass


func set_health(new_health: int) -> void:
	health = mini(new_health, base_health)
	sprite.set_health(health)


func set_colour(new_colour: Globals.Colour) -> void:
	colour = new_colour
	sprite.set_colour(new_colour)


func enable_hurtbox(enable: bool) -> void:
	pass


func enable_attack_warning_indicator(enable: bool) -> void:
	pass


func enable_stun_indicator(enable: bool) -> void:
	pass


func move_forward(delta: float, desired_location: Vector2 = Globals.player.global_position, custom_move_speed = move_speed) -> void:
	if is_stunned():
		play_move_animation(false)
		return
	if global_position.distance_to(desired_location) <= 10:
		sleeping = true
		play_move_animation(false)
		return
	rotation = lerp_angle(rotation, (desired_location - global_position).angle(), 5.0 * delta)
	linear_velocity = Vector2.from_angle(rotation) * custom_move_speed
	apply_force(linear_velocity)
	play_move_animation(true)


func knock_back(force: float, duration_in_seconds: float) -> void:
	knock_back_timer.start(duration_in_seconds)
	linear_velocity = Vector2(0, 0)
	apply_impulse((global_position - Globals.player.global_position).normalized() * force)


func stun(duration_in_seconds: float) -> void:
	stunned_timer.start(maxf(stunned_timer.time_left, duration_in_seconds))
	linear_velocity = Vector2(0, 0)
	sleeping = true
	play_move_animation(false)


func is_stunned() -> bool:
	if !stunned_timer.is_stopped() || !knock_back_timer.is_stopped():
		return true
	return false


func set_invulnerable(duration_in_seconds: float) -> void:
	invulnerable_timer.start(maxf(invulnerable_timer.time_left, duration_in_seconds))


func is_invulnerable() -> bool:
	if !invulnerable_timer.is_stopped():
		return true
	return false


func player_is_within_distance(distance := 500.0) -> bool:
	return (global_position - Globals.player.global_position).length() < distance


func get_appendages() -> Array[Appendage]:
	return []


func _on_area_entered(area: Area2D) -> void:
	var bullet = area as Bullet
	if bullet == null:
		return

	UpgradeManager.on_enemy_hit(bullet, self)
	ConditionManager.on_enemy_hit(bullet, self)

	if is_invulnerable():
		return

	var log_context_data = {
		"enemy": get_script().get_global_name() + str(get_instance_id()), "bullet": bullet.get_script().get_global_name() + str(bullet.get_instance_id())
	}
	var log_play_data = {}

	if bullet.colour != colour:
		SfxManager.play_sound("EnemyDeflectSFX", -5.0, -3.0, 0.95, 1.05)

		log_play_data = {"message": "Enemy hit with wrong colour", "context": log_context_data}
		Logger.log_play_data(log_play_data)
		return

	set_health(health - bullet.damage)
	ConditionManager.on_enemy_received_damage(bullet, self)
	SfxManager.play_sound("EnemyHitSFX", -20.0, -18.0, 1, 1.2)

	log_play_data = {"message": "Enemy hit for " + str(bullet.damage) + " damage", "context": log_context_data}
	Logger.log_play_data(log_play_data)

	if health <= 0:
		log_play_data = {"message": "Enemy killed", "context": log_context_data}
		Logger.log_play_data(log_play_data)
		ScreenFreezer.freeze(0.05)
		UpgradeManager.on_enemy_killed(self)
		SignalBus.emit_signal("enemy_died", self)
		spawn_death_particles()
		queue_free()


func _on_regen_timer_timeout() -> void:
	if health < base_health:
		set_health(health + health_regen)


func play_move_animation(_play: bool) -> void:
	pass


func play_attack_animation() -> void:
	pass


func spawn_death_particles() -> void:
	pass
