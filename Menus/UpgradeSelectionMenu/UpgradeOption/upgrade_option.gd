class_name UpgradeOption
extends Control

signal upgrade_option_selected(upgrade_option: UpgradeOption)

const UPGRADE_BOX_1 = preload("res://Menus/UpgradeSelectionMenu/UpgradeOption/Upgrade Box 1.png")
const UPGRADE_BOX_2 = preload("res://Menus/UpgradeSelectionMenu/UpgradeOption/Upgrade Box 2.png")
const UPGRADE_BOX_3 = preload("res://Menus/UpgradeSelectionMenu/UpgradeOption/Upgrade Box 3.png")

var upgrade: Upgrade

@onready var upgrade_option_bg: Sprite2D = $UpgradeOptionBG
@onready var upgrade_option_name_label: Label = $UpgradeOptionNameLabel
@onready var upgrade_option_description_label: Label = $UpgradeOptionDescriptionLabel
@onready var upgrade_icon: Sprite2D = $UpgradeHex/UpgradeIcon
@onready var points_cost_label: Label = $PointsCostLabel
@onready var button: Button = $Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match randi() % 3:
		0:
			upgrade_option_bg.texture = UPGRADE_BOX_1
			upgrade_option_bg.position = Vector2(150, 123)
		1:
			upgrade_option_bg.texture = UPGRADE_BOX_2
			upgrade_option_bg.position = Vector2(150, 133)
		2:
			upgrade_option_bg.texture = UPGRADE_BOX_3
			upgrade_option_bg.position = Vector2(150, 123)
	if upgrade:
		upgrade_option_name_label.text = upgrade.name
		upgrade_option_description_label.text = upgrade.description
		upgrade_icon.texture = upgrade.icon
		points_cost_label.text = str(upgrade.points_cost) + " POINT(s)"


func set_upgrade(new_upgrade: Upgrade) -> void:
	upgrade = new_upgrade


func set_visibility(set_visibility: bool) -> void:
	for child in get_children():
		child.visible = false


func disabled(set_disabled: bool) -> void:
	button.disabled = set_disabled
	button.focus_mode = FOCUS_NONE


func _on_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	upgrade_option_selected.emit(self)


func _on_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)
