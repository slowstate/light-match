class_name PlayerUpgradeButton
extends TextureButton

var upgrade: Upgrade

@onready var hex_sprite: Sprite2D = $HexSprite
@onready var icon_sprite: Sprite2D = $IconSprite
@onready var tooltip: Sprite2D = $Tooltip
@onready var hover_tooltip_name: Panel = $Tooltip/HoverTooltipName
@onready var hover_tooltip_name_label: Label = $Tooltip/HoverTooltipName/HoverTooltipNameLabel
@onready var hover_tooltip_description: Panel = $Tooltip/HoverTooltipDescription
@onready var hover_tooltip_description_label: Label = $Tooltip/HoverTooltipDescription/HoverTooltipDescriptionLabel
@onready var counter_label: Label = $CounterLabel


func _ready() -> void:
	icon_sprite.texture = upgrade.icon
	hover_tooltip_name_label.text = upgrade.name.to_upper()
	hover_tooltip_description_label.text = upgrade.description
	tooltip.visible = false
	SignalBus.upgrade_activated.connect(_on_upgrade_activated)
	SignalBus.upgrade_deactivated.connect(_on_upgrade_deactivated)
	upgrade.trigger_counter_update()


func _process(_delta: float) -> void:
	var global_mouse_position = get_global_mouse_position()
	tooltip.global_position = Vector2(global_mouse_position.x, global_mouse_position.y)


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
	hover_tooltip_name.size = Vector2(hover_tooltip_name_label.size.x + 20, hover_tooltip_name_label.size.y + 20)


func _on_hover_tooltip_description_label_resized() -> void:
	hover_tooltip_description.size = Vector2(hover_tooltip_description_label.size.x + 20, hover_tooltip_description_label.size.y + 20)


func _on_upgrade_counter_updated(counter: int) -> void:
	counter_label.text = str(counter)


func _on_upgrade_activated(activated_upgrade: Upgrade) -> void:
	if activated_upgrade == upgrade:
		hex_sprite.modulate.a = 1.0
		icon_sprite.modulate.a = 1.0


func _on_upgrade_deactivated(deactivated_upgrade: Upgrade) -> void:
	if deactivated_upgrade == upgrade:
		hex_sprite.modulate.a = 0.5
		icon_sprite.modulate.a = 0.5
