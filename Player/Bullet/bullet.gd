class_name Bullet
extends Area2D

@export var sprite_2d: Sprite2D
@export var collision_shape_2d: CollisionShape2D

var direction: Vector2
var damage: int
var speed: float
var colour: Globals.Colour

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer_value(Globals.CollisionLayer.Bullets, true)
	set_collision_mask_value(Globals.CollisionLayer.Enemies, true)
	_setup()

# This function should be overriden by inheriting classes; not code should be added to this class
func _setup() -> void:
	# Keep this empty as child nodes will override this function
	pass
	
func _set_sprite_colour() -> void:
	var sprite2d_texture: GradientTexture2D = sprite_2d.texture
	sprite2d_texture.gradient.colors[0] = Globals.ColourVisualValue[colour]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if colour:
		var velocity = direction * speed
		sprite_2d.rotation = -velocity.angle()
		translate(velocity * delta)


func _on_body_entered(body: Node2D) -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	queue_free()
