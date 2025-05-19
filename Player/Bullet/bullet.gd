class_name Bullet
extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

const BULLET: PackedScene = preload("res://Player/Bullet/bullet.tscn")

var direction: Vector2
var damage: int
var speed: float
var colour: Globals.BulletColour

static func create(colour: Globals.BulletColour, position: Vector2, direction: Vector2, damage := 1, speed := 1000.0) -> Bullet:
	var new_bullet: Bullet = BULLET.instantiate()
	new_bullet.colour = colour
	new_bullet.global_position = position
	new_bullet.direction = direction.normalized()
	new_bullet.damage = damage
	new_bullet.speed = speed
	return new_bullet
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var texture: GradientTexture2D = sprite_2d.texture
	match colour:
		Globals.BulletColour.Red:
			texture.gradient.colors[0] = Color.RED
		Globals.BulletColour.Green:
			texture.gradient.colors[0] = Color.GREEN
		Globals.BulletColour.Blue:
			texture.gradient.colors[0] = Color.DEEP_SKY_BLUE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = direction * speed
	sprite_2d.rotation = -velocity.angle()
	translate(velocity * delta)


func _on_body_entered(body: Node2D) -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	queue_free()
