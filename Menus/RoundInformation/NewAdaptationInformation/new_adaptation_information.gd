class_name NewAdaptionInformation
extends Control

var upgrade: Upgrade

@onready var adaptation_name_label: Label = $AdaptationNameLabel
@onready var adaptation_description_label: Label = $AdaptationDescriptionLabel
@onready var upgrade_icon: Sprite2D = $UpgradeHex/UpgradeIcon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if upgrade == null:
		return
	adaptation_name_label.text = upgrade.name
	adaptation_description_label.text = upgrade.description
	upgrade_icon.texture = upgrade.icon
