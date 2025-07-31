class_name MainMenuButton
extends Button

@export var collision_shape_2d: CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_collision_shape()


func update_collision_shape() -> void:
	size = get_minimum_size()
	collision_shape_2d.position = Vector2(size.x / 2, size.y / 2)
	var rectShape = collision_shape_2d.shape as RectangleShape2D
	rectShape.size = Vector2(size.x - 4, size.y - 2)
