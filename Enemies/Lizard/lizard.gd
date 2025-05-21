class_name Lizard
extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var head: Area2D = $Head

const LIZARD: PackedScene = preload("res://Enemies/Lizard/lizard.tscn")

var direction: Vector2
var health := 1
var DAMAGE := 1
var MOVE_SPEED := 300.0
var colour: Globals.Colour
var head_colour: Globals.Colour

static func create(lizard_colour: Globals.Colour, head_colour: Globals.Colour, lizard_position: Vector2) -> Lizard:
	var new_lizard: Lizard = LIZARD.instantiate()
	new_lizard.colour = lizard_colour
	new_lizard.head_colour = head_colour
	new_lizard.global_position = lizard_position
	return new_lizard


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer_value(Globals.CollisionLayer.Enemies, true)
	set_collision_mask_value(Globals.CollisionLayer.Bullets, true)
	set_collision_mask_value(Globals.CollisionLayer.Boundaries, true)
	self.area_entered.connect(_on_area_entered)
	_set_sprite_colour()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation = direction.angle()


func _set_sprite_colour() -> void:
	match colour:
		Globals.Colour.Blue: sprite_2d.texture = load("res://Enemies/Colours/Blue/enemy_blue.png")
		Globals.Colour.Green: sprite_2d.texture = load("res://Enemies/Colours/Green/enemy_green.png")
		Globals.Colour.Red: sprite_2d.texture = load("res://Enemies/Colours/Red/enemy_red.png")


func _on_area_entered(bullet: Bullet) -> void:
	if bullet.colour != colour: return
	health -= 1
	if health <= 0:
		queue_free()
