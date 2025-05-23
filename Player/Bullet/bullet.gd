class_name Bullet
extends Area2D

@export var sprite_2d: Sprite2D
@export var collision_shape_2d: CollisionShape2D

var colour: Globals.Colour
var direction: Vector2
var damage: int
var speed: float
var collision_check_ray_cast := RayCast2D.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer_value(Globals.CollisionLayer.BULLETS, true)
	set_collision_mask_value(Globals.CollisionLayer.ENEMIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BOUNDARIES, true)
	# Pre-emptive collision detector
	add_child(collision_check_ray_cast)
	collision_check_ray_cast.global_position = global_position
	collision_check_ray_cast.collide_with_areas = true
	collision_check_ray_cast.hit_from_inside = true

	_setup()


# This function should be overriden by inheriting classes; no code should be added to this class
func _setup() -> void:
	# Keep this empty as child nodes will override this function
	pass


func set_sprite_colour() -> void:
	var sprite2d_texture: GradientTexture2D = sprite_2d.texture
	sprite2d_texture.gradient.colors[0] = Globals.COLOUR_VISUAL_VALUE[colour]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !colour:
		return

	var velocity = direction * speed
	rotation = velocity.angle()
	collision_check_ray_cast.target_position = Vector2(speed * delta, 0)
	#if _check_if_collision_on_next_frame(delta):
	#return
	if collision_check_ray_cast.is_colliding():
		global_position = collision_check_ray_cast.get_collision_point()
	else:
		translate(velocity * delta)


# TODO: Fix bullets clipping through objects (star in particular)
#func _check_if_collision_on_next_frame(delta: float) -> bool:
#get_world_2d().space
#var from = global_position
#var to = from + direction * speed * delta
#var space_state = get_world_2d().direct_space_state
#var Parameters = PhysicsRayQueryParameters2D.create(from, to)
#
##var result = space_state.intersect_ray(from, to, [], 1)  # Ignore self (bullet) and trigger collisions
#var result = space_state.intersect_ray(Parameters)
#
#if result:
#var collider = result.collider
#if collider and collider.has_method("_on_area_entered"):
#collider._on_area_entered(self, result.position)
#
#queue_free()  # Destroy bullet after hit
#return true
#
#return false


func on_body_entered(_body: Node2D) -> void:
	queue_free()


func on_area_entered(_area: Area2D) -> void:
	queue_free()
