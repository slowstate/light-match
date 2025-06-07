class_name UpgradeOption
extends Control

signal upgrade_selected(upgrade: Upgrade)

var upgrade: Upgrade
@onready var upgrade_option_name_label: Label = $UpgradeOptionNameLabel
@onready var upgrade_option_description_label: Label = $UpgradeOptionDescriptionLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if upgrade:
		upgrade_option_name_label.text = upgrade.name
		upgrade_option_description_label.text = upgrade.description


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_upgrade(new_upgrade: Upgrade) -> void:
	upgrade = new_upgrade


func _on_button_pressed() -> void:
	upgrade_selected.emit(upgrade)
