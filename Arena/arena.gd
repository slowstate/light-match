class_name Arena
extends Node2D

@export var current_round_number: int = 1

var main_menu = load("res://Menus/MainMenu/main_menu.tscn")
var palettes_cleared_this_round: int = 0
var total_enemies_to_spawn_this_round: int = 0
var palette_milestone_1_this_round: int = 0
var palette_milestone_2_this_round: int = 0

@onready var round_number_label: Label = $UserInterface/RoundLabel/RoundNumberLabel
@onready var time_limit_timer: Timer = $UserInterface/TimeLimitLabel/TimeLimitTimer
@onready var state_machine: ArenaStateMachine = $StateMachine
@onready var palette_milestone_label: Label = $UserInterface/PaletteMilestone/PaletteMilestoneLabel
@onready var palette_milestone_1: Sprite2D = $UserInterface/PaletteMilestone/PaletteMilestone1
@onready var palette_milestone_2: Sprite2D = $UserInterface/PaletteMilestone/PaletteMilestone2


func _ready() -> void:
	time_limit_timer.start(1800)


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


func _on_time_limit_timer_timeout() -> void:
	state_machine.on_child_transition("ScoreScreen")
