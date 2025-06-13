class_name UpgradeOption
extends Control

signal upgrade_selected(upgrade: Upgrade)

const UPGRADE_BOX_1 = preload("res://Menus/UpgradeSelectionMenu/UpgradeOption/Upgrade Box 1.png")
const UPGRADE_BOX_2 = preload("res://Menus/UpgradeSelectionMenu/UpgradeOption/Upgrade Box 2.png")
const UPGRADE_BOX_3 = preload("res://Menus/UpgradeSelectionMenu/UpgradeOption/Upgrade Box 3.png")

var upgrade: Upgrade
@onready var upgrade_option_bg: Sprite2D = $UpgradeOptionBG
@onready var upgrade_option_name_label: Label = $UpgradeOptionNameLabel
@onready var upgrade_option_description_label: Label = $UpgradeOptionDescriptionLabel
@onready var upgrade_icon: Sprite2D = $UpgradeHex/UpgradeIcon
@onready var button: Button = $Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.disabled = true
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
		upgrade_icon.position.y = 7 if upgrade.type == UpgradeManager.UpgradeTypes.LUCKY_DICE else 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_upgrade(new_upgrade: Upgrade) -> void:
	upgrade = new_upgrade


func _on_button_pressed() -> void:
	upgrade_selected.emit(upgrade)


func _on_initial_disabled_timer_timeout() -> void:
	button.set_deferred("disabled", false)
