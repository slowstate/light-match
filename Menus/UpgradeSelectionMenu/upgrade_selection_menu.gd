class_name UpgradeSelectionMenu
extends Node2D

signal upgrade_selection_completed

const UPGRADE_SELECTION_MENU = preload("res://Menus/UpgradeSelectionMenu/upgrade_selection_menu.tscn")
const UPGRADE_OPTION = preload("res://Menus/UpgradeSelectionMenu/UpgradeOption/upgrade_option.tscn")

var number_of_upgrade_options: int = 2
var currently_selected_upgrade: Upgrade

@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var replace_upgrade_label: Label = $ReplaceUpgradeLabel


static func create(number_of_upgrade_options: int) -> UpgradeSelectionMenu:
	var upgrade_selection_menu: UpgradeSelectionMenu = UPGRADE_SELECTION_MENU.instantiate()
	upgrade_selection_menu.number_of_upgrade_options = number_of_upgrade_options
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
		h_box_container.add_child(new_upgrade_option)


func pick_upgrades_from_pickable_upgrades(
	number_of_upgrade_options: int, pickable_upgrades: Array[UpgradeManager.UpgradeTypes]
) -> Array[UpgradeManager.UpgradeTypes]:
	var picked_upgrades: Array[UpgradeManager.UpgradeTypes]
	for n in number_of_upgrade_options:
		var random_upgrade_option = pickable_upgrades.pick_random()
		picked_upgrades.push_back(random_upgrade_option)
		pickable_upgrades.erase(random_upgrade_option)
	return picked_upgrades


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_cancel"):
		Globals.player.enable_player_upgrade_buttons(false)


func on_upgrade_option_selected(selected_upgrade: Upgrade):
	if Globals.player.upgrades.size() < 5:
		Globals.player.add_upgrade(selected_upgrade)
		_clean_up_menu()
		upgrade_selection_completed.emit()
	else:
		currently_selected_upgrade = selected_upgrade
		Globals.player.enable_player_upgrade_buttons(true)
		replace_upgrade_label.visible = true


func _on_button_pressed() -> void:
	_clean_up_menu()
	upgrade_selection_completed.emit()


func _clean_up_menu() -> void:
	for upgrade_option in h_box_container.get_children():
		h_box_container.remove_child(upgrade_option)
		upgrade_option.queue_free()
	Globals.player.enable_player_upgrade_buttons(false)
	replace_upgrade_label.visible = false


func _on_upgrade_removed(upgrade: Upgrade) -> void:
	Globals.player.add_upgrade(currently_selected_upgrade)
	_clean_up_menu()
	upgrade_selection_completed.emit()
