class_name Enemy
extends Area2D

@export var colour: Globals.Colour
@export var health := 1
@export var damage := 1
@export var move_speed := 300.0
@export var rotation_speed := 2.0
@export var sprite: EnemySprite

var desired_rotation: float
var is_frozen: bool = false


static func create(_initial_position: Vector2, _initial_health: int, _initial_colour: Globals.Colour = Globals.pick_random_colour()) -> Enemy:
	assert(null, "This method should be overridden by subclasses.")
	return null


func _ready() -> void:
	set_collision_layer_value(Globals.CollisionLayer.BOUNDARIES, false)
	set_collision_layer_value(Globals.CollisionLayer.ENEMIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BOUNDARIES, false)
	set_collision_mask_value(Globals.CollisionLayer.BULLETS, true)

	self.area_entered.connect(_on_area_entered)
	sprite.set_health(health)
	sprite.set_colour(colour)
	UpgradeManager.on_enemy_spawned(self)
	_setup()


func _process(delta: float) -> void:
	if player_is_within_distance(40.0):
		sprite.play_attack_animation()
	rotate_to_target(delta, desired_rotation)
	_update(delta)


# This function should be overriden by inheriting classes; no code should be added to this class
func _setup() -> void:
	# Keep this empty as child nodes will override this function
	pass


func _update(_delta: float) -> void:
	pass


func rotate_to_target(delta: float, target_rotation: float) -> void:
	if is_frozen:
		return
	var angle_diff = wrapf(target_rotation - rotation, -PI, PI)
	var max_rotation_delta = rotation_speed * delta
	rotation += clamp(angle_diff, -max_rotation_delta, max_rotation_delta)


func move_forward(delta: float) -> void:
	if is_frozen:
		return
	sprite.play_move_animation(true)
	translate(Vector2(cos(rotation), sin(rotation)) * move_speed * delta)


func player_is_within_distance(distance := 500.0) -> bool:
	return (global_position - Globals.player.global_position).length() < distance


func _on_area_entered(area: Area2D) -> void:
	var bullet = area as Bullet
	bullet.damage = UpgradeManager.on_enemy_hit(bullet, self).damage
	if bullet.colour != colour:
		return
	health -= bullet.damage
	sprite.set_health(health)
	if health <= 0:
		UpgradeManager.on_enemy_killed(self)
		SignalBus.emit_signal("enemy_died", self)
		queue_free()
