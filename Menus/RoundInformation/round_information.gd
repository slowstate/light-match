class_name RoundInformation
extends CanvasLayer

signal round_information_continue

const NEW_ADAPTATION_INFORMATION = preload("res://Menus/RoundInformation/NewAdaptationInformation/new_adaptation_information.tscn")
const NEW_CONDITION_INFORMATION = preload("res://Menus/RoundInformation/NewConditionInformation/new_condition_information.tscn")

@onready var h_box_container: HBoxContainer = $VBoxContainer/HBoxContainer
@onready var label: Label = $VBoxContainer/Label


func clear_information() -> void:
	for child in h_box_container.get_children():
		h_box_container.remove_child(child)
		child.queue_free()


func display_new_condition(condition: Condition) -> void:
	label.text = condition.added_dialogue


func display_new_adaptation(upgrade: Upgrade) -> void:
	label.text = upgrade.added_dialogue
	var new_adaptation_information = NEW_ADAPTATION_INFORMATION.instantiate()
	new_adaptation_information.upgrade = upgrade
	h_box_container.add_child(new_adaptation_information)


func _on_continue_button_pressed() -> void:
	round_information_continue.emit()
