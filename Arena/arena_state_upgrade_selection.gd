class_name ConditionAndAdaptationSelectionState
extends State

const CONDITION_AND_ADAPTATION_NOTIFICATION = preload("res://Menus/ConditionAndAdaptationNotification/condition_and_adaptation_notification.tscn")

var arena
var condition_and_adaptation_notification

@onready var upgrade_selection_interface: CanvasLayer = $UpgradeSelectionInterface


func enter() -> void:
	arena = owner as Arena
	assert(arena != null, "Arena is null.")
	arena.current_round_number += 1
	condition_and_adaptation_notification = CONDITION_AND_ADAPTATION_NOTIFICATION.instantiate()
	condition_and_adaptation_notification.upgrade_selection_completed.connect(on_upgrade_selected)
	condition_and_adaptation_notification.add_child.call_deferred(condition_and_adaptation_notification)
	Globals.player.controls_enabled = false


func exit() -> void:
	condition_and_adaptation_notification.queue_free()


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func on_upgrade_selected() -> void:
	transition.emit("RoundActive")
