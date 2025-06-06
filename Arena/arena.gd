class_name Arena
extends Node2D

@export var current_round_number: int = 1

var palettes_cleared_this_round: int
var total_enemies_to_spawn_this_round: int

@onready var round_number_label: Label = $UserInterface/RoundNumberLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	round_number_label.text = "Round " + str(current_round_number)
