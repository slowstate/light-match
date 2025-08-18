class_name UpgradeSelectionMenu
extends Node2D

signal upgrade_selection_completed

const CONDITION_OPTION = preload("res://Menus/UpgradeSelectionMenu/ConditionOption/condition_option.tscn")
const UPGRADE_OPTION = preload("res://Menus/UpgradeSelectionMenu/UpgradeOption/upgrade_option.tscn")

var number_of_upgrade_options: int = 3
var currently_selected_upgrade_option: UpgradeOption

@onready var condition_options: HBoxContainer = $ConditionOptions
@onready var upgrade_options: HBoxContainer = $UpgradeOptions
@onready var replace_upgrade_label: Label = $ReplaceUpgradeLabel
@onready var continue_bg: Sprite2D = $ContinueBG


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.upgrade_removed.connect(_on_upgrade_removed)
	generate_upgrade_options()
	generate_condition_options()
	disable_upgrade_options_that_cannot_be_afforded()
	continue_bg.visible = true


#region Condition option generation
func generate_condition_options() -> void:
	var picked_conditions: Array[Condition]
	var pickable_conditions = ConditionManager.ALL_CONDITIONS.duplicate()
	for n in 3:
		var random_condition = pickable_conditions.pick_random()
		picked_conditions.push_back(random_condition.new())
		pickable_conditions.erase(random_condition)

	for picked_condition in picked_conditions:
		var new_condition_option = CONDITION_OPTION.instantiate()
		new_condition_option.condition_selected.connect(on_condition_option_selected)
		new_condition_option.condition = picked_condition
		condition_options.add_child(new_condition_option)


func on_condition_option_selected(condition: Condition) -> void:
	Globals.player.add_condition(condition)
	continue_bg.visible = true


#endregion


#region Upgrade option generation
func generate_upgrade_options() -> void:
	var picked_upgrades: Array[UpgradeManager.UpgradeTypes] = pick_upgrades_from_pickable_upgrades(
		number_of_upgrade_options, UpgradeManager.get_pickable_upgrades()
	)
	for picked_upgrade in picked_upgrades:
		var new_upgrade_option = UPGRADE_OPTION.instantiate()
		new_upgrade_option.upgrade_option_selected.connect(on_upgrade_option_selected)
		new_upgrade_option.set_upgrade(UpgradeManager.ALL_UPGRADES[picked_upgrade].new())
		upgrade_options.add_child(new_upgrade_option)

	var upgrade_option_strings = []
	for upgrade_option in upgrade_options.get_children():
		upgrade_option_strings.append((upgrade_option as UpgradeOption).upgrade.name)
	var player_upgrade_strings = []
	for player_upgrade in Globals.player.upgrades:
		player_upgrade_strings.append(player_upgrade.name)

	var log_context_data = {"player_upgrades": player_upgrade_strings, "upgrade_options": upgrade_option_strings}
	var log_play_data = {"message": "Upgrade selection", "context": log_context_data}
	Logger.log_play_data(log_play_data)


func pick_upgrades_from_pickable_upgrades(number_of_upgrades: int, pickable_upgrades: Array[UpgradeManager.UpgradeTypes]) -> Array[UpgradeManager.UpgradeTypes]:
	var picked_upgrades: Array[UpgradeManager.UpgradeTypes]
	for n in number_of_upgrades:
		var random_upgrade_option = pickable_upgrades.pick_random()
		picked_upgrades.push_back(random_upgrade_option)
		pickable_upgrades.erase(random_upgrade_option)
	return picked_upgrades


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_cancel"):
		Globals.player.enable_player_upgrade_buttons(false)


func on_upgrade_option_selected(selected_upgrade_option: UpgradeOption):
	if Globals.player.upgrades.size() < Globals.player.max_upgrades:
		var log_context_data = {"selected_upgrade": selected_upgrade_option.upgrade.name}
		var log_play_data = {"message": "Upgrade selected", "context": log_context_data}
		Logger.log_play_data(log_play_data)

		selected_upgrade_option.set_purchased()
		Globals.player.add_upgrade(selected_upgrade_option.upgrade)
		Globals.player.add_points(-selected_upgrade_option.upgrade.points_cost)
		disable_upgrade_options_that_cannot_be_afforded()
	else:
		currently_selected_upgrade_option = selected_upgrade_option
		Globals.player.enable_player_upgrade_buttons(true)
		replace_upgrade_label.visible = true


func _on_upgrade_removed(_upgrade: Upgrade) -> void:
	var log_context_data = {"selected_upgrade": currently_selected_upgrade_option.upgrade.name}
	var log_play_data = {"message": "Upgrade selected", "context": log_context_data}
	Logger.log_play_data(log_play_data)

	currently_selected_upgrade_option.set_purchased()
	Globals.player.add_upgrade(currently_selected_upgrade_option.upgrade)
	Globals.player.add_points(-currently_selected_upgrade_option.upgrade.points_cost)
	disable_upgrade_options_that_cannot_be_afforded()


func disable_upgrade_options_that_cannot_be_afforded() -> void:
	for child in upgrade_options.get_children():
		var upgrade_option = child as UpgradeOption
		if upgrade_option.upgrade.points_cost > Globals.player.points:
			upgrade_option.disabled(true)


func _on_continue_button_pressed() -> void:
	var log_context_data = {"selected_upgrade": "None"}
	var log_play_data = {"message": "Upgrade selected", "context": log_context_data}
	Logger.log_play_data(log_play_data)

	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	_clean_up_menu()
	upgrade_selection_completed.emit()


func _clean_up_menu() -> void:
	for upgrade_option in upgrade_options.get_children():
		upgrade_options.remove_child(upgrade_option)
		upgrade_option.queue_free()
	Globals.player.enable_player_upgrade_buttons(false)
	replace_upgrade_label.visible = false


func _on_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)
#endregion
