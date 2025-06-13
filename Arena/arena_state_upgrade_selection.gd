class_name UpgradeSelectionState
extends State

const UPGRADE_SELECTION_MENU = preload("res://Menus/UpgradeSelectionMenu/upgrade_selection_menu.tscn")

var arena
var upgrade_selection_menu

@onready var upgrade_selection_interface: CanvasLayer = $UpgradeSelectionInterface


func enter() -> void:
	arena = owner as Arena
	assert(arena != null, "Arena is null.")
	var number_of_upgrade_options: int = 2
	if arena.palettes_cleared_this_round >= arena.palette_milestone_1_this_round:
		number_of_upgrade_options += 1
	if arena.palettes_cleared_this_round >= arena.palette_milestone_2_this_round:
		number_of_upgrade_options += 1
	upgrade_selection_menu = UpgradeSelectionMenu.create(number_of_upgrade_options)
	upgrade_selection_menu.upgrade_selection_completed.connect(on_upgrade_selected)
	upgrade_selection_interface.add_child.call_deferred(upgrade_selection_menu)
	Globals.player.controls_enabled = false


func exit() -> void:
	upgrade_selection_menu.queue_free()


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func on_upgrade_selected() -> void:
	arena.current_round_number += 1
	transition.emit("RoundActive")
