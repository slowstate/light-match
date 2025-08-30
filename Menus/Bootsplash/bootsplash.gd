extends ColorRect

var MAIN_MENU = load("res://Menus/MainMenu/main_menu.tscn")

@onready var label: Label = $Label
@onready var fade_in_timer: Timer = $FadeInTimer
@onready var still_timer: Timer = $StillTimer
@onready var fade_out_timer: Timer = $FadeOutTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.modulate.a = 0.0
	fade_in_timer.start(2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !fade_in_timer.is_stopped():
		label.modulate.a = lerp(0.0, 1.0, 1 - fade_in_timer.time_left / fade_in_timer.wait_time)
	if !fade_out_timer.is_stopped():
		label.modulate.a = lerp(1.0, 0.0, 1 - fade_out_timer.time_left / fade_out_timer.wait_time)


func _on_fade_in_timer_timeout() -> void:
	still_timer.start(1)


func _on_still_timer_timeout() -> void:
	fade_out_timer.start(1)


func _on_fade_out_timer_timeout() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)
