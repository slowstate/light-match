extends Node2D

signal upgrade_selection_completed

const UPGRADE_OPTION = preload("res://Menus/UpgradeSelectionMenu/UpgradeOption/upgrade_option.tscn")

var number_of_upgrades: int
var currently_selected_upgrade: Upgrade

@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var replace_upgrade_label: Label = $ReplaceUpgradeLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.upgrade_removed.connect(on_upgrade_removed)
	var pickable_upgrades = get_pickable_upgrades(number_of_upgrades)
	for n in pickable_upgrades.size():
		var new_upgrade_option = UPGRADE_OPTION.instantiate()
		new_upgrade_option.upgrade_selected.connect(on_upgrade_option_selected)
		new_upgrade_option.set_upgrade(pickable_upgrades[n])
		h_box_container.add_child(new_upgrade_option)


func get_pickable_upgrades(number_of_upgrades: int) -> Array[Upgrade]:
	var pickable_upgrades = UpgradeManager.ALL_UPGRADES.duplicate()
	for upgrade in Globals.player.upgrades.size():
		pickable_upgrades.erase(Globals.player.upgrades[upgrade].type)

	var picked_upgrades: Array[Upgrade]
	for n in number_of_upgrades:
		if pickable_upgrades.size() <= 0:
			continue
		var random_upgrade_type = pickable_upgrades.keys().pick_random()
		var random_upgrade = pickable_upgrades.get(random_upgrade_type)
		picked_upgrades.append(random_upgrade.new())
		pickable_upgrades.erase(random_upgrade_type)

	return picked_upgrades


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_cancel"):
		Globals.player.enable_player_upgrade_buttons(false)


func on_upgrade_option_selected(selected_upgrade: Upgrade):
	if Globals.player.upgrades.size() < 5:
		Globals.player.add_upgrades([selected_upgrade])
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


func on_upgrade_removed(upgrade: Upgrade) -> void:
	Globals.player.add_upgrades([currently_selected_upgrade])
	_clean_up_menu()
	upgrade_selection_completed.emit()
