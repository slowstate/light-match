extends Label


func _physics_process(_delta: float) -> void:
	var text_string = tr("MAIN_MENU_LIFETIME_SEQUENCES") + ": {lifetime_palettes}\n"
	text_string += tr("MAIN_MENU_FIRE_RATE") + ": {fire_rate}%\n"
	text_string += tr("MAIN_MENU_MAX_HEALTH") + ": {max_health}"
	var fire_rate = Save.lifetime_palettes * 0.002 * 100
	var max_health = clampi(floori(Save.lifetime_palettes / 100.0), 0, 6)
	text = text_string.format({"lifetime_palettes": Save.lifetime_palettes, "fire_rate": fire_rate, "max_health": max_health})
