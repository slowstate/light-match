class_name PlayerUpgradeButton
extends TextureButton

var upgrade: Upgrade

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var tooltip: Sprite2D = $Tooltip
@onready var hover_tooltip_name: ColorRect = $Tooltip/HoverTooltipName
@onready var hover_tooltip_name_inner: ColorRect = $Tooltip/HoverTooltipName/HoverTooltipNameInner
@onready var hover_tooltip_name_label: Label = $Tooltip/HoverTooltipName/HoverTooltipNameLabel
@onready var hover_tooltip_description: ColorRect = $Tooltip/HoverTooltipDescription
@onready var hover_tooltip_description_inner: ColorRect = $Tooltip/HoverTooltipDescription/HoverTooltipDescriptionInner
@onready var hover_tooltip_description_label: Label = $Tooltip/HoverTooltipDescription/HoverTooltipDescriptionLabel
@onready var counter_label: Label = $CounterLabel


func _ready() -> void:
	sprite_2d.texture = upgrade.icon
	sprite_2d.position.y = 47 if upgrade.type == UpgradeManager.UpgradeTypes.LUCKY_DICE else 40
	hover_tooltip_name_label.text = upgrade.name.to_upper()
	hover_tooltip_description_label.text = upgrade.description
	tooltip.visible = false
	upgrade.trigger_counter_update()


func _process(_delta: float) -> void:
	var global_mouse_position = get_global_mouse_position()
	tooltip.global_position = Vector2(global_mouse_position.x, global_mouse_position.y)
	sprite_2d.modulate.a = 0.5 if disabled else 1.0


func setup(new_upgrade: Upgrade) -> void:
	upgrade = new_upgrade
	upgrade.upgrade_counter_updated.connect(_on_upgrade_counter_updated)


func _on_pressed() -> void:
	SignalBus.upgrade_removed.emit(upgrade)


func _on_mouse_entered() -> void:
	tooltip.visible = true


func _on_mouse_exited() -> void:
	tooltip.visible = false


func _on_hover_tooltip_name_label_resized() -> void:
	hover_tooltip_name_inner.size = Vector2(hover_tooltip_name_label.size.x + 20, hover_tooltip_name_label.size.y + 2)
	hover_tooltip_name.size = Vector2(hover_tooltip_name_inner.size.x + 10, hover_tooltip_name_inner.size.y + 10)


func _on_hover_tooltip_description_label_resized() -> void:
	hover_tooltip_description_inner.size = Vector2(hover_tooltip_description_label.size.x + 20, hover_tooltip_description_label.size.y + 2)
	hover_tooltip_description.size = Vector2(hover_tooltip_description_inner.size.x + 10, hover_tooltip_description_inner.size.y + 10)


func _on_upgrade_counter_updated(counter: int) -> void:
	counter_label.text = str(counter)
