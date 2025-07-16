class_name ConditionLabel
extends Control

var condition: Condition

@onready var name_label: Label = $NameLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_label.text = condition.name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
