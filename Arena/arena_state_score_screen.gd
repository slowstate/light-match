class_name ScoreScreenState
extends State

var main_menu = load("res://Menus/MainMenu/main_menu.tscn")
var arena
@onready var score_interface: CanvasLayer = $ScoreInterface
@onready var round_label: Label = $ScoreInterface/RoundLabel
@onready var time_label: Label = $ScoreInterface/TimeLabel


func _ready() -> void:
	score_interface.visible = false


func enter() -> void:
	arena = owner as Arena
	assert(arena != null, "Arena is null.")
	Globals.player.game_over_sequence()
	round_label.text = "You reached round " + str(arena.current_round_number)
	var time_limit_timer_elapsed_time: float = arena.time_limit_timer.wait_time - arena.time_limit_timer.time_left
	time_label.text = (
		"You survived for " + str(floori(time_limit_timer_elapsed_time / 60.0)) + ":" + str(floori(time_limit_timer_elapsed_time) % 60).pad_zeros(2)
	)
	score_interface.visible = true

	var log_context_data = {"round_number": arena.current_round_number, "survival_time": Time.get_time_string_from_unix_time(time_limit_timer_elapsed_time)}
	var log_play_data = {"message": "Run ended", "context": log_context_data}
	Logger.log_play_data(log_play_data)


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func _on_main_menu_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_packed", main_menu)
