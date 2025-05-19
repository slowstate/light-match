extends Area2D
class_name Bot

@onready var sprite_2d: Sprite2D = $Sprite2D

const BOT: PackedScene = preload("res://Enemies/Bot/bot.tscn")

var direction: Vector2
var MAX_HEALTH := 1
var health := MAX_HEALTH
var DAMAGE := 1
var MOVE_SPEED := 300.0
var colour: Globals.BulletColour

static func create(colour: Globals.BulletColour, position: Vector2) -> Bot:
	var new_bot: Bot = BOT.instantiate()
	new_bot.colour = colour
	new_bot.global_position = position
	return new_bot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.player:
		var direction_to_player = (Globals.player.global_position - global_position).normalized()
		var velocity = direction_to_player * MOVE_SPEED
		sprite_2d.rotation = velocity.angle()
		translate(velocity * delta)

func _calculate_path():
	pass


func _on_area_entered(area: Area2D) -> void:
	health -= 1
	if health <= 0:
		queue_free()
