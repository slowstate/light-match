class_name Arena
extends Node2D

@export var current_round_number: int = 1

var main_menu = load("res://Menus/MainMenu/main_menu.tscn")
var palettes_cleared_this_round: int = 0
var total_enemies_to_spawn_this_round: int = 0

@onready var meter_fill: ColorRect = $UserInterface/PaletteGoalMeter/MeterBackground/MeterFill
@onready var round_number_label: Label = $UserInterface/RoundLabel/RoundNumberLabel
@onready var first_extra_upgrade_milestone_label: Label = $UserInterface/PaletteGoalMeter/FirstExtraUpgradeMilestoneLabel
@onready var second_extra_upgrade_milestone_label: Label = $UserInterface/PaletteGoalMeter/SecondExtraUpgradeMilestoneLabel
@onready var time_limit_timer: Timer = $UserInterface/TimeLimitLabel/TimeLimitTimer
@onready var state_machine: ArenaStateMachine = $StateMachine


func _ready() -> void:
	time_limit_timer.start(1800)
	first_extra_upgrade_milestone_label.text = str(floori(float(total_enemies_to_spawn_this_round) / 3.0 * 0.3))
	second_extra_upgrade_milestone_label.text = str(floori(float(total_enemies_to_spawn_this_round) / 3.0 * 0.8))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	round_number_label.text = str(current_round_number)
	if palettes_cleared_this_round <= floori(total_enemies_to_spawn_this_round / 3 * 0.8):
		meter_fill.scale.y = float(palettes_cleared_this_round) / float(floori(total_enemies_to_spawn_this_round / 3 * 0.8))


func _on_time_limit_timer_timeout() -> void:
	state_machine.on_child_transition("ScoreScreen")
