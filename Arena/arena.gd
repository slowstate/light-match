class_name Arena
extends Node2D

@export var current_round_number: int = 15

var main_menu = load("res://Menus/MainMenu/main_menu.tscn")
var total_enemies_to_spawn_this_round: int = 0
var enemy_types_to_spawn: Array[Globals.EnemyType]
var palette_milestone_1_this_round: int = 0
var palette_milestone_2_this_round: int = 0
var palettes_cleared_this_round: int = 0

@onready var round_number_label: Label = $UserInterface/RoundLabel/RoundNumberLabel
@onready var time_limit_timer: Timer = $UserInterface/TimeLimitLabel/TimeLimitTimer
@onready var state_machine: ArenaStateMachine = $StateMachine
@onready var round_active: RoundActiveState = $StateMachine/RoundActive
@onready var palette_milestone_label: Label = $UserInterface/PaletteMilestone/PaletteMilestoneLabel
@onready var palette_milestone_1: Sprite2D = $UserInterface/PaletteMilestone/PaletteMilestone1
@onready var palette_milestone_2: Sprite2D = $UserInterface/PaletteMilestone/PaletteMilestone2
@onready var music_manager: Node2D = $MusicManager
@onready var timer_0_12s: Timer = $"MusicManager/Timer0-12s"
@onready var timer_12_30s: Timer = $"MusicManager/Timer12-30s"
@onready var timer_30_39s: Timer = $"MusicManager/Timer30-39s"
@onready var timer_39_48s: Timer = $"MusicManager/Timer39-48s"
@onready var timer_48_60s: Timer = $"MusicManager/Timer48-60s"
@onready var timer_60_78s: Timer = $"MusicManager/Timer60-78s"
@onready var timer_78_90s: Timer = $"MusicManager/Timer78-90s"



func _ready() -> void:
	time_limit_timer.start(1800)
	music_manager.update_music(0.0)
	timer_0_12s.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	round_number_label.text = str(current_round_number)

	palette_milestone_label.text = str(palettes_cleared_this_round)
	palette_milestone_label.modulate.a = 0.3
	palette_milestone_1.modulate.a = 0.3
	palette_milestone_2.modulate.a = 0.3
	if palettes_cleared_this_round >= palette_milestone_1_this_round:
		palette_milestone_1.modulate.a = 1.0
		palette_milestone_label.modulate.a = 0.6
	if palettes_cleared_this_round >= palette_milestone_2_this_round:
		palette_milestone_2.modulate.a = 1.0
		palette_milestone_label.modulate.a = 1.0


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


func _on_time_limit_timer_timeout() -> void:
	state_machine.on_child_transition("ScoreScreen")
