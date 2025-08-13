extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var text_string = """Lifetime Chains: {lifetime_palettes}
	Permanent fire rate gained: {fire_rate}%
	Permanent max health gained: {max_health}"""
	var fire_rate = Save.lifetime_palettes * 0.002 * 100
	var max_health = floori(Save.lifetime_palettes / 100)
	text = text_string.format({"lifetime_palettes": Save.lifetime_palettes, "fire_rate": fire_rate, "max_health": max_health})
