class_name Arena
extends Node2D

@export var current_round_number: int = 0

var main_menu = load("res://Menus/MainMenu/main_menu.tscn")
var total_enemies_to_spawn_this_round: int = 0
var enemy_types_to_spawn: Array[Globals.EnemyType]
var palette_milestone_1_this_round: int = 0
var palette_milestone_2_this_round: int = 0
var palettes_cleared_this_run: int = 0

@onready var round_number_label: Label = $UserInterface/RoundNumberLabel
@onready var state_machine: ArenaStateMachine = $StateMachine
@onready var round_active: RoundActiveState = $StateMachine/RoundActive
@onready var animation_player: AnimationPlayer = $BG/AnimationPlayer
@onready var music_manager: Node2D = $MusicManager
@onready var timer_0_12s: Timer = $"MusicManager/Timer0-12s"
@onready var timer_12_30s: Timer = $"MusicManager/Timer12-30s"
@onready var timer_30_39s: Timer = $"MusicManager/Timer30-39s"
@onready var timer_39_48s: Timer = $"MusicManager/Timer39-48s"
@onready var timer_48_60s: Timer = $"MusicManager/Timer48-60s"
@onready var timer_60_78s: Timer = $"MusicManager/Timer60-78s"
@onready var timer_78_90s: Timer = $"MusicManager/Timer78-90s"


func _ready() -> void:
	var log_data = {"message": "Scene ready"}
	Logger.log_info(log_data)
	var log_play_data = {"message": "Run started"}
	Logger.log_play_data(log_play_data)
	animation_player.play("Arena_Lights")
	music_manager.update_music(0.0)
	timer_0_12s.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	round_number_label.text = str(current_round_number)


func _on_timer_012s_timeout() -> void:
	music_manager.update_music(12.0)
	timer_12_30s.start()


func _on_timer_1230s_timeout() -> void:
	music_manager.update_music(30.0)
	timer_30_39s.start()


func _on_timer_3039s_timeout() -> void:
	music_manager.update_music(39.0)
	timer_39_48s.start()


func _on_timer_3948s_timeout() -> void:
	music_manager.update_music(48.0)
	timer_48_60s.start()


func _on_timer_4860s_timeout() -> void:
	music_manager.update_music(60.0)
	timer_60_78s.start()


func _on_timer_6078s_timeout() -> void:
	music_manager.update_music(78.0)
	timer_78_90s.start()


func _on_timer_7890s_timeout() -> void:
	music_manager.update_music(0.0)
	timer_0_12s.start()


func _on_main_menu_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
