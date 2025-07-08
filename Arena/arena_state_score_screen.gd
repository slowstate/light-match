class_name ScoreScreenState
extends State

var main_menu = load("res://Menus/MainMenu/main_menu.tscn")
var arena

@onready var score_interface: CanvasLayer = $ScoreInterface
@onready var round_label: Label = $ScoreInterface/RoundLabel


func _ready() -> void:
	score_interface.visible = false


func enter() -> void:
	arena = owner as Arena
	assert(arena != null, "Arena is null.")
	Globals.player.game_over_sequence()
	round_label.text = "You reached round " + str(arena.current_round_number)
	score_interface.visible = true

	var log_context_data = {"round_number": arena.current_round_number}
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
