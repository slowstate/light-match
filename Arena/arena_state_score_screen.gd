class_name ScoreScreenState
extends State

var main_menu = load("res://Menus/MainMenu/main_menu.tscn")
var arena

@onready var game_over_label: Label = $ScoreInterface/VBoxContainer/GameOverLabel
@onready var score_interface: CanvasLayer = $ScoreInterface
@onready var score_info_label: Label = $ScoreInterface/VBoxContainer/ScoreInfoLabel
@onready var max_health_progress_bar: ProgressBar = $ScoreInterface/VBoxContainer/HBoxContainer/MaxHealthProgressBar
@onready var max_health_progress_bar_timer: Timer = $ScoreInterface/VBoxContainer/HBoxContainer/MaxHealthProgressBar/MaxHealthProgressBarTimer
@onready var max_health_gained_label: Label = $ScoreInterface/VBoxContainer/HBoxContainer/MaxHealthGainedLabel


func _ready() -> void:
	score_interface.visible = false
	max_health_progress_bar.value = 0
	max_health_gained_label.text = ""


func enter() -> void:
	arena = owner as Arena
	assert(arena != null, "Arena is null.")
	Save.lifetime_palettes += arena.palettes_cleared_this_run
	Save.save_user_save()
	Globals.player.game_over_sequence()
	if arena.current_round_number > 10:
		game_over_label.text = tr("ARENA_CONGRATULATIONS")
		score_info_label.text = tr("ARENA_CONGRATULATIONS_ROUNDS_COMPLETED") + "\n"
	else:
		game_over_label.text = tr("ARENA_YOU_FAILED")
		score_info_label.text = tr("ARENA_YOU_FAILED_ROUNDS_COMPLETED") + " " + str(arena.current_round_number) + "\n"
	score_info_label.text += tr("ARENA_SEQUENCES_COMPLETED_1") + " " + str(arena.palettes_cleared_this_run) + " " + tr("ARENA_SEQUENCES_COMPLETED_2") + "\n"
	score_info_label.text += tr("ARENA_FIRE_RATE_GAINED") + ": " + str(arena.palettes_cleared_this_run * 0.002 * 100) + "%\n"
	score_interface.visible = true
	max_health_progress_bar_timer.start(2)
	var log_context_data = {"round_number": arena.current_round_number}
	var log_play_data = {"message": "Run ended", "context": log_context_data}
	Logger.log_play_data(log_play_data)


func exit() -> void:
	pass


func update(_delta: float) -> void:
	if score_interface.visible:
		if floori((Save.lifetime_palettes - arena.palettes_cleared_this_run) / 100) < floori((Save.lifetime_palettes) / 100):
			max_health_progress_bar.value = lerpf(0.0, 100.0, ease(1 - max_health_progress_bar_timer.time_left / max_health_progress_bar_timer.wait_time, 0.5))
		else:
			max_health_progress_bar.value = lerpf(
				0.0, float((Save.lifetime_palettes) % 100), ease(1 - max_health_progress_bar_timer.time_left / max_health_progress_bar_timer.wait_time, 0.5)
			)
		# TODO: Change colour of progress bar when value == 100


func physics_update(_delta: float) -> void:
	pass


func _on_main_menu_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_packed", main_menu)


func _on_max_health_progress_bar_timer_timeout() -> void:
	if floori((Save.lifetime_palettes - arena.palettes_cleared_this_run) / 100) < floori((Save.lifetime_palettes) / 100):
		max_health_gained_label.text = "+" + str(floori(arena.palettes_cleared_this_run) / 100) + " " + tr("ARENA_HP")
