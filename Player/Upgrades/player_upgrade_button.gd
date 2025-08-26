class_name PlayerUpgradeButton
extends TextureButton

var upgrade: Upgrade
@onready var hex_sprite: Sprite2D = $HexSprite
@onready var icon_sprite: Sprite2D = $HexSprite/IconSprite
@onready var counter_label: Label = $CounterLabel


func _ready() -> void:
	icon_sprite.texture = upgrade.icon
	tooltip_text = upgrade.name.to_upper() + ": " + upgrade.description
	_set_active(upgrade.is_active)
	upgrade.trigger_counter_update()


func _process(_delta: float) -> void:
	var global_mouse_position = get_global_mouse_position()
	_set_active(upgrade.is_active)


func setup(new_upgrade: Upgrade) -> void:
	upgrade = new_upgrade
	upgrade.upgrade_counter_updated.connect(_on_upgrade_counter_updated)


func _on_pressed() -> void:
	SignalBus.upgrade_removed.emit(upgrade)


func _on_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)


func _on_upgrade_counter_updated(counter: int) -> void:
	counter_label.text = str(counter)


func _set_active(active: bool) -> void:
	if active:
		hex_sprite.modulate.a = 1.0
		icon_sprite.modulate.a = 1.0
	else:
		hex_sprite.modulate.a = 0.5
		icon_sprite.modulate.a = 0.5
