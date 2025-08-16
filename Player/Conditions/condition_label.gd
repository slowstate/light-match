class_name ConditionLabel
extends Label

var condition: Condition


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = condition.name
	tooltip_text = condition.description
