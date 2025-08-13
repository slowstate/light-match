class_name NewConditionInformation
extends Control

var condition: Condition

@onready var condition_name_label: Label = $ConditionNameLabel
@onready var condition_description_label: Label = $ConditionDescriptionLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if condition == null:
		return
	condition_name_label.text = condition.name
	condition_description_label.text = condition.description
