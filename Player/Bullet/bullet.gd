class_name Bullet
extends Area2D

const BULLET = preload("res://Player/Bullet/bullet.tscn")
const GUN_PARTICLES = preload("res://Player/VFX/gun_particles.tscn")

var bullet_id: String
var colour: Globals.Colour = Globals.Colour.BLUE
var angle: float
var damage: int
var speed: float

@onready var sprite: Sprite2D = $Sprite
@onready var collision_check_ray_cast: RayCast2D = $CollisionCheckRayCast


static func create(bullet_position: Vector2, bullet_angle: float, bullet_colour: Globals.Colour, bullet_damage := 1, bullet_speed := 1500.0) -> Bullet:
	var new_bullet: Bullet = BULLET.instantiate()
	new_bullet.global_position = bullet_position
	new_bullet.angle = bullet_angle
	new_bullet.colour = bullet_colour
	new_bullet.damage = bullet_damage
	new_bullet.speed = bullet_speed
	return new_bullet


func _init() -> void:
	bullet_id = Globals.generate_guid()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer_value(Globals.CollisionLayer.BULLETS, true)
	set_collision_mask_value(Globals.CollisionLayer.ENEMIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BOUNDARIES, true)
	sprite.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	rotation = angle
	scale *= 1.0 + (damage - 1.0) / 2.0


func _physics_process(delta: float) -> void:
	if !colour:
		return

	var velocity = Vector2.from_angle(angle).normalized() * speed
	collision_check_ray_cast.target_position = Vector2(48 + speed * delta, 0)
	if collision_check_ray_cast.is_colliding():
		global_position = collision_check_ray_cast.get_collision_point()
		var collided_shape := collision_check_ray_cast.get_collider()
		if collided_shape as Enemy != null:
			(collided_shape as Enemy)._on_area_entered(self)
			spawn_hit_particles()
			_on_area_entered(collided_shape)
		elif collided_shape as Area2D != null:
			spawn_hit_particles()
			(collided_shape as Area2D)._on_area_entered(self)
			_on_area_entered(collided_shape)
		else:
			spawn_hit_particles()
			if collided_shape.get_parent().get_name() == "TitleIcon":
				SfxManager.play_sound("EnemyHitSFX", -25.0, -23.0, 2.0, 2.2)
			else:
				SfxManager.play_sound("EnemyDeflectSFX", -5.0, -3.0, 0.95, 1.05)
			_on_body_entered(collided_shape)
	else:
		global_position += velocity * delta
		UpgradeManager.on_bullet_travelled_x_pixels(self, velocity.length() * delta)


func _on_area_entered(_area: Area2D) -> void:
	if get_tree().current_scene.name == "Arena":
		var log_context_data = {
			"bullet": get_script().get_global_name() + str(get_instance_id()), "collider": _area.owner.name + str(_area.owner.get_instance_id())
		}
		var log_play_data = {"message": "Bullet collided", "context": log_context_data}
		Logger.log_play_data(log_play_data)
	queue_free()


func _on_body_entered(_body: Node2D) -> void:
	if get_tree().current_scene.name == "Arena":
		var log_context_data = {"bullet": get_script().get_global_name() + str(get_instance_id()), "collider": _body.name + str(_body.get_instance_id())}
		var log_play_data = {"message": "Bullet collided", "context": log_context_data}
		Logger.log_play_data(log_play_data)
	queue_free()


func spawn_hit_particles() -> void:
	var gun_particles = GUN_PARTICLES.instantiate()
	gun_particles.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	gun_particles.global_position = global_position
	gun_particles.rotation = angle
	gun_particles.emitting = true
	get_tree().root.add_child(gun_particles)


func _on_despawn_timer_timeout() -> void:
	queue_free()
