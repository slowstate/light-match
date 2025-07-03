class_name UpgradeSelectionMenu
extends Node2D

signal upgrade_selection_completed

const UPGRADE_SELECTION_MENU = preload("res://Menus/UpgradeSelectionMenu/upgrade_selection_menu.tscn")
const UPGRADE_OPTION = preload("res://Menus/UpgradeSelectionMenu/UpgradeOption/upgrade_option.tscn")

var number_of_upgrade_options: int = 2
var currently_selected_upgrade: Upgrade

@onready var upgrade_options: HBoxContainer = $UpgradeOptions
@onready var replace_upgrade_label: Label = $ReplaceUpgradeLabel


static func create(initial_number_of_upgrade_options: int) -> UpgradeSelectionMenu:
	var upgrade_selection_menu: UpgradeSelectionMenu = UPGRADE_SELECTION_MENU.instantiate()
	upgrade_selection_menu.number_of_upgrade_options = initial_number_of_upgrade_options
	return upgrade_selection_menu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.upgrade_removed.connect(_on_upgrade_removed)
	var picked_upgrades: Array[UpgradeManager.UpgradeTypes] = pick_upgrades_from_pickable_upgrades(
		number_of_upgrade_options, UpgradeManager.get_pickable_upgrades()
	)
	for picked_upgrade in picked_upgrades:
		var new_upgrade_option = UPGRADE_OPTION.instantiate()
		new_upgrade_option.upgrade_selected.connect(on_upgrade_option_selected)
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


func on_upgrade_option_selected(selected_upgrade: Upgrade):
	if Globals.player.upgrades.size() < 5:
		var log_context_data = {"selected_upgrade": selected_upgrade.name}
		var log_play_data = {"message": "Upgrade selected", "context": log_context_data}
		Logger.log_play_data(log_play_data)

		Globals.player.add_upgrade(selected_upgrade)
		_clean_up_menu()
		upgrade_selection_completed.emit()
	else:
		currently_selected_upgrade = selected_upgrade
		Globals.player.enable_player_upgrade_buttons(true)
		replace_upgrade_label.visible = true


func _on_skip_button_pressed() -> void:
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


func _on_upgrade_removed(_upgrade: Upgrade) -> void:
	var log_context_data = {"selected_upgrade": currently_selected_upgrade.name}
	var log_play_data = {"message": "Upgrade selected", "context": log_context_data}
	Logger.log_play_data(log_play_data)

	Globals.player.add_upgrade(currently_selected_upgrade)
	_clean_up_menu()
	upgrade_selection_completed.emit()


func _on_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)
