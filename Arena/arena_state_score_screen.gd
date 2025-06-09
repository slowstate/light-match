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
	assert(arena != null, "The state type must be used only in the Bot scene. It needs the owner to be a Bot node.")
	await Globals.player.is_node_ready()
	Globals.player.game_over_sequence()
	round_label.text = "You reached round " + str(arena.current_round_number)
	var time_limit_timer_elapsed_time: float = arena.time_limit_timer.wait_time - arena.time_limit_timer.time_left
	time_label.text = (
		"You survived for " + str(floori(time_limit_timer_elapsed_time / 60.0)) + ":" + str(floori(time_limit_timer_elapsed_time) % 60).pad_zeros(2)
	)
	score_interface.visible = true


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func _on_main_menu_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_packed", main_menu)
