extends Control

@onready var data_label: Label = $VBoxContainer/DataLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_cancel"):
		visible = false


func update_data() -> void:
	var text_string = tr("MAIN_MENU_LIFETIME_SEQUENCES") + ": {lifetime_palettes}\n"
	text_string += tr("MAIN_MENU_FIRE_RATE") + ": {fire_rate}%\n"
	text_string += tr("MAIN_MENU_MAX_HEALTH") + ": {max_health}"
	var fire_rate = Save.lifetime_palettes * 0.002 * 100
	var max_health = clampi(floori(Save.lifetime_palettes / 100.0), 0, 6)
	data_label.text = text_string.format({"lifetime_palettes": Save.lifetime_palettes, "fire_rate": fire_rate, "max_health": max_health})
