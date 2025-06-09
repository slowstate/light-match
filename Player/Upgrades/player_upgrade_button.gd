class_name PlayerUpgradeButton
extends Button

var upgrade: Upgrade

@onready var hover_tooltip: ColorRect = $HoverTooltip
@onready var hover_tooltip_label: Label = $HoverTooltip/HoverTooltipLabel
@onready var counter_label: Label = $CounterLabel


func _ready() -> void:
	hover_tooltip_label.text = upgrade.name.to_upper() + "\n" + upgrade.description
	hover_tooltip.visible = false
	upgrade.trigger_counter_update()


func _process(delta: float) -> void:
	var global_mouse_position = get_global_mouse_position()
	hover_tooltip.global_position = Vector2(global_mouse_position.x + 10, global_mouse_position.y + 10)


func setup(upgrade: Upgrade) -> void:
	self.upgrade = upgrade
	upgrade.upgrade_counter_updated.connect(_on_upgrade_counter_updated)
	text = str(upgrade.type)


func _on_pressed() -> void:
	SignalBus.upgrade_removed.emit(upgrade)


func _on_mouse_entered() -> void:
	hover_tooltip.visible = true


func _on_mouse_exited() -> void:
	hover_tooltip.visible = false


func _on_hover_tooltip_label_resized() -> void:
	hover_tooltip.size = Vector2(hover_tooltip_label.size.x + 20, hover_tooltip_label.size.y + 20)


func _on_upgrade_counter_updated(counter: int) -> void:
	counter_label.text = str(counter)
