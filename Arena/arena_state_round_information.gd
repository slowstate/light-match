class_name RoundInformationState
extends State

var arena

@onready var round_information: RoundInformation = $RoundInformation


func enter() -> void:
	arena = owner as Arena
	assert(arena != null, "Arena is null.")
	arena.current_round_number += 1
	if !round_information.round_information_continue.is_connected(_on_round_information_continue):
		round_information.round_information_continue.connect(_on_round_information_continue)
	Globals.player.controls_enabled = false
	round_information.clear_information()
	_apply_round_changes_and_display_round_information()


func _apply_round_changes_and_display_round_information() -> void:
	round_information.visible = true
	match arena.current_round_number:
		1:
			_on_round_information_continue()
		2:
			var new_condition = ConditionManager.ChromaticReaction.new()
			Globals.player.add_condition(new_condition)
			round_information.display_new_condition(new_condition)
		3:
			var new_adaptation = UpgradeManager.Taser.new()
			Globals.player.add_upgrade(new_adaptation)
			round_information.display_new_adaptation(new_adaptation)
		4:
			var new_condition = ConditionManager.PhotonAbsorption.new()
			Globals.player.add_condition(new_condition)
			round_information.display_new_condition(new_condition)
		5:
			var new_adaptation = UpgradeManager.AdrenalineInjection.new()
			Globals.player.add_upgrade(new_adaptation)
			round_information.display_new_adaptation(new_adaptation)
		6:
			var new_condition = ConditionManager.Supercharged.new()
			Globals.player.add_condition(new_condition)
			round_information.display_new_condition(new_condition)
		7:
			var new_adaptation = UpgradeManager.StunGrenade.new()
			Globals.player.add_upgrade(new_adaptation)
			round_information.display_new_adaptation(new_adaptation)
		8:
			var new_condition = ConditionManager.UltravioletJamming.new()
			Globals.player.add_condition(new_condition)
			round_information.display_new_condition(new_condition)
		9:
			var new_adaptation = UpgradeManager.ExosuitOverdrive.new()
			Globals.player.add_upgrade(new_adaptation)
			round_information.display_new_adaptation(new_adaptation)
		10:
			var new_condition = ConditionManager.FrequencyDisruption.new()
			Globals.player.add_condition(new_condition)
			round_information.display_new_condition(new_condition)
		_:
			Logger.log_error({"message": "Round number does not exist."})


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func _on_round_information_continue() -> void:
	round_information.visible = false
	transition.emit("RoundActive")
