extends Control

signal condition_selected(condition: Condition)

var condition: Condition

@onready var name_label: Label = $NameLabel
@onready var description_label: Label = $DescriptionLabel
@onready var reward_label: Label = $RewardLabel
@onready var button: Button = $Button
@onready var applied_bg: Sprite2D = $AppliedBG


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	applied_bg.visible = false
	if condition != null:
		name_label.text = condition.name
		description_label.text = condition.description
		reward_label.text = "+" + str(condition.points_per_round) + " POINT(s) per Round"


func _on_button_pressed() -> void:
	button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.focus_mode = Control.FOCUS_NONE
	applied_bg.visible = true
	condition_selected.emit(condition)
