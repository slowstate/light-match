extends Control

signal condition_selected(condition: Condition)

var condition: Condition

@onready var name_label: Label = $NameLabel
@onready var description_label: Label = $DescriptionLabel
@onready var reward_label: Label = $RewardLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if condition:
		name_label.text = condition.name
		description_label.text = condition.description
		reward_label.text = "+" + str(condition.points_per_round) + " POINTs per Test"


func _on_button_pressed() -> void:
	condition_selected.emit(condition)
	for child in get_children():
		child.visible = false
