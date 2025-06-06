class_name UpgradeSelectionState
extends State

const UPGRADE_SELECTION_MENU = preload("res://Menus/UpgradeSelectionMenu/upgrade_selection_menu.tscn")
@onready var upgrade_selection_interface: CanvasLayer = $UpgradeSelectionInterface

var arena
var upgrade_selection_menu


func enter() -> void:
	arena = owner as Arena
	assert(arena != null, "The state type must be used only in the Bot scene. It needs the owner to be a Bot node.")
	await Globals.player.is_node_ready()
	upgrade_selection_menu = UPGRADE_SELECTION_MENU.instantiate()
	if arena.palettes_cleared_this_round > arena.total_enemies_to_spawn_this_round / 3 * 0.8:
		upgrade_selection_menu.number_of_upgrades = 4
	elif arena.palettes_cleared_this_round > arena.total_enemies_to_spawn_this_round / 3 * 0.3:
		upgrade_selection_menu.number_of_upgrades = 3
	else:
		upgrade_selection_menu.number_of_upgrades = 2
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
