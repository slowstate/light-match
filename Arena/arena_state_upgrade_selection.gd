class_name ConditionAndAdaptationSelectionState
extends State

const UPGRADE_SELECTION_MENU = preload("res://Menus/UpgradeSelectionMenu/upgrade_selection_menu.tscn")

var arena
var upgrade_selection_menu

@onready var upgrade_selection_interface: CanvasLayer = $UpgradeSelectionInterface


func enter() -> void:
	arena = owner as Arena
	assert(arena != null, "Arena is null.")
	arena.current_round_number += 1
	upgrade_selection_menu = UPGRADE_SELECTION_MENU.instantiate()
	upgrade_selection_menu.upgrade_selection_completed.connect(on_upgrade_selected)
	upgrade_selection_interface.add_child.call_deferred(upgrade_selection_menu)
	Globals.player.controls_enabled = false
	Globals.player.add_end_of_round_points()


func exit() -> void:
	upgrade_selection_menu.queue_free()


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func on_upgrade_selected() -> void:
	transition.emit("RoundActive")
