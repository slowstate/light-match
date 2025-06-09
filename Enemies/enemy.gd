class_name Enemy
extends Area2D

@export var colour: Globals.Colour
@export var health := 1
@export var damage := 1
@export var move_speed := 300.0
@export var rotation_speed := 2.0
@export var sprite: EnemySprite

var desired_rotation: float
var can_move: bool = true
var knocked_back: bool = false
var knock_back_position: Vector2
var knock_back_distance: float
var knock_back_speed: float = 300.0


static func create(_initial_position: Vector2, _initial_health: int, _initial_colour: Globals.Colour = Globals.pick_random_colour()) -> Enemy:
	assert(null, "This method should be overridden by subclasses.")
	return null


func _ready() -> void:
	set_collision_layer_value(Globals.CollisionLayer.BOUNDARIES, false)
	set_collision_layer_value(Globals.CollisionLayer.ENEMIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BOUNDARIES, false)
	set_collision_mask_value(Globals.CollisionLayer.ENEMIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BULLETS, true)

	self.area_entered.connect(_on_area_entered)
	sprite.set_health(health)
	set_colour(colour)
	UpgradeManager.on_enemy_spawned(self)
	_setup()


func _physics_process(delta: float) -> void:
	if player_is_within_distance(40.0):
		sprite.play_attack_animation()
	rotate_to_target(delta, desired_rotation)
	if knocked_back:
		translate(
			(
				ease((knock_back_position - global_position).length() / knock_back_distance, 1.0)
				* (knock_back_position - global_position).normalized()
				* knock_back_speed
				* knock_back_distance
				/ 100
				* 2
				* delta
			)
		)
		if (knock_back_position - global_position).length() < 20.0:
			knocked_back = false

	_update(delta)


# This function should be overriden by inheriting classes; no code should be added to this class
func _setup() -> void:
	# Keep this empty as child nodes will override this function
	pass


func _update(_delta: float) -> void:
	pass


func set_colour(colour: Globals.Colour) -> void:
	self.colour = colour
	sprite.set_colour(colour)


func rotate_to_target(delta: float, target_rotation: float) -> void:
	if !can_move:
		return
	var angle_diff = wrapf(target_rotation - rotation, -PI, PI)
	var max_rotation_delta = rotation_speed * delta
	rotation += clamp(angle_diff, -max_rotation_delta, max_rotation_delta)


func move_forward(delta: float) -> void:
	if !can_move || knocked_back:
		return
	sprite.play_move_animation(true)
	translate(Vector2(cos(rotation), sin(rotation)) * move_speed * delta)


func knock_back(player_global_position: Vector2, knock_back_distance: float) -> void:
	knock_back_position = global_position + (global_position - player_global_position).normalized() * knock_back_distance
	self.knock_back_distance = knock_back_distance
	knocked_back = true


func player_is_within_distance(distance := 500.0) -> bool:
	return (global_position - Globals.player.global_position).length() < distance


func _on_area_entered(area: Area2D) -> void:
	var bullet = area as Bullet
	UpgradeManager.on_enemy_hit(bullet, self)
	if bullet.colour != colour:
		return
	health -= bullet.damage
	sprite.set_health(health)
	if health <= 0:
		UpgradeManager.on_enemy_killed(self)
		SignalBus.emit_signal("enemy_died", self)
		queue_free()
