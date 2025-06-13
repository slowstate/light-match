extends HBoxContainer

const PLAYER_UPGRADE_BUTTON = preload("res://Player/Upgrades/player_upgrade_button.tscn")

var player: Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = owner as Player
	assert(player != null, "Player is null.")


func update_player_upgrades_interface() -> void:
	get_children().clear()
	for upgrade in player.upgrades:
		var new_upgrade_button = PLAYER_UPGRADE_BUTTON.instantiate()
		new_upgrade_button.upgrade = upgrade
		add_child(new_upgrade_button)
