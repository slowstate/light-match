@tool
class_name StunIndicator
extends Sprite2D

@export var custom_offset: Vector2

@onready var percentage_completion_bar: Sprite2D = $PercentageCompletionBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	percentage_completion_bar.scale.y = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position = get_parent().global_position + custom_offset


func set_stun_percentage_completion(percentage_complete: float) -> void:
	percentage_completion_bar.scale.y = percentage_complete
