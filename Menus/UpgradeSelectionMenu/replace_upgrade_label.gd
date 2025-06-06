extends Label


func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if visible:
		label_settings.font_color.a = 1 if roundi(Time.get_unix_time_from_system() * 2) % 2 == 0 else 0
