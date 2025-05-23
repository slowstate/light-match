class_name Enemy
extends Area2D

@export var colour: Globals.Colour
@export var health := 1
@export var damage := 1
@export var move_speed := 300.0
@export var rotation_speed := 2.0

var desired_rotation: float


static func create(initial_position: Vector2, initial_colour: Globals.Colour = Globals.pick_random_colour()) -> Enemy:
	assert(null, "This method should be overridden by subclasses.")
	return null


func _ready() -> void:
	set_collision_layer_value(Globals.CollisionLayer.BOUNDARIES, false)
	set_collision_layer_value(Globals.CollisionLayer.ENEMIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BOUNDARIES, false)
	set_collision_mask_value(Globals.CollisionLayer.BULLETS, true)

	self.area_entered.connect(_on_area_entered)
	_setup()


# This function should be overriden by inheriting classes; no code should be added to this class
func _setup() -> void:
	# Keep this empty as child nodes will override this function
	pass


func rotate_to_target(delta: float, target_rotation: float) -> void:
	var angle_diff = wrapf(target_rotation - rotation, -PI, PI)
	var max_rotation_delta = rotation_speed * delta
	rotation += clamp(angle_diff, -max_rotation_delta, max_rotation_delta)


func move_forward(delta: float) -> void:
	translate(Vector2(cos(rotation), sin(rotation)) * move_speed * delta)


func _on_area_entered(area: Area2D) -> void:
	var bullet = area as Bullet
	if bullet.colour != colour:
		return
	health -= 1
	if health <= 0:
		SignalBus.emit_signal("enemy_died", self)
		queue_free()
