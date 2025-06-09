class_name UpgradeSelectionState
extends State

const UPGRADE_SELECTION_MENU = preload("res://Menus/UpgradeSelectionMenu/upgrade_selection_menu.tscn")

var arena
var upgrade_selection_menu

@onready var upgrade_selection_interface: CanvasLayer = $UpgradeSelectionInterface


func enter() -> void:
	arena = owner as Arena
	assert(arena != null, "The state type must be used only in the Bot scene. It needs the owner to be a Bot node.")
	await Globals.player.is_node_ready()
	var number_of_upgrade_options: int = 2
	if arena.palettes_cleared_this_round > arena.total_enemies_to_spawn_this_round / 3 * 0.3:
		number_of_upgrade_options += 1
	if arena.palettes_cleared_this_round > arena.total_enemies_to_spawn_this_round / 3 * 0.8:
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
