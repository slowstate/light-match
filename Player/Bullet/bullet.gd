class_name Bullet
extends Area2D

@onready var sprite: Sprite2D = $Sprite
@onready var collision_check_ray_cast: RayCast2D = $CollisionCheckRayCast

var bullet_id: String
var colour: Globals.Colour
var angle: float
var damage: int
var speed: float

const BULLET = preload("res://Player/Bullet/bullet.tscn")


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


func _physics_process(delta: float) -> void:
	if !colour:
		return

	var velocity = Vector2.from_angle(angle).normalized() * speed
	collision_check_ray_cast.target_position = Vector2(48 + speed * delta, 0)
	if collision_check_ray_cast.is_colliding():
		global_position = collision_check_ray_cast.get_collision_point()
		var collided_shape := collision_check_ray_cast.get_collider()
		if collided_shape as Area2D:
			collided_shape._on_area_entered(self)
			_on_area_entered(collided_shape)
		else:
			_on_body_entered(collided_shape)
	else:
		translate(velocity * delta)
		UpgradeManager.on_bullet_travelled_x_pixels(self, velocity.length() * delta)


func _on_area_entered(area: Area2D) -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()
