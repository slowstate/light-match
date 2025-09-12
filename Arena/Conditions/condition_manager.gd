extends Node

const Aggression = preload("res://Arena/Conditions/aggression.gd")
const Brittle = preload("res://Arena/Conditions/brittle.gd")
const Bulletproof = preload("res://Arena/Conditions/bulletproof.gd")
const ChromaticReaction = preload("res://Arena/Conditions/chromatic_reaction.gd")
const Fortify = preload("res://Arena/Conditions/fortify.gd")
const FrequencyDisruption = preload("res://Arena/Conditions/frequency_disruption.gd")
const Headstrong = preload("res://Arena/Conditions/headstrong.gd")
const Poise = preload("res://Arena/Conditions/poise.gd")
const PhotonAbsorption = preload("res://Arena/Conditions/photon_absorption.gd")
const Recovery = preload("res://Arena/Conditions/recovery.gd")
const Rush = preload("res://Arena/Conditions/rush.gd")
const SelfRepair = preload("res://Arena/Conditions/self_repair.gd")
const Shield = preload("res://Arena/Conditions/shield.gd")
const Supercharged = preload("res://Arena/Conditions/supercharged.gd")
const Swarm = preload("res://Arena/Conditions/swarm.gd")
const Swift = preload("res://Arena/Conditions/swift.gd")
const Transcendence = preload("res://Arena/Conditions/transcendence.gd")
const UltravioletJamming = preload("res://Arena/Conditions/ultraviolet_jamming.gd")

var ALL_CONDITIONS = [
	Aggression,
	Brittle,
	Bulletproof,
	ChromaticReaction,
	Fortify,
	FrequencyDisruption,
	Headstrong,
	PhotonAbsorption,
	Poise,
	Recovery,
	Rush,
	SelfRepair,
	Shield,
	Supercharged,
	Swarm,
	Swift,
	Transcendence,
	UltravioletJamming,
]


#region
func on_condition_added(new_condition: Condition) -> void:
	for condition in get_player_conditions():
		condition.on_condition_added(new_condition)


func on_palette_failed(player: Player) -> void:
	for condition in get_player_conditions():
		condition.on_palette_failed(player)


func on_round_loaded(loaded_round: Round) -> void:
	for condition in get_player_conditions():
		condition.on_round_loaded(loaded_round)


func on_enemy_spawned(enemy: Enemy) -> void:
	for condition in get_player_conditions():
		condition.on_enemy_spawned(enemy)


func on_enemy_pre_slowed(enemy: Enemy, move_speed_effect: MoveSpeedEffect) -> void:
	for condition in get_player_conditions():
		condition.on_enemy_pre_slowed(enemy, move_speed_effect)


func on_enemy_slowed(enemy: Enemy, move_speed_effect: MoveSpeedEffect) -> void:
	for condition in get_player_conditions():
		condition.on_enemy_slowed(enemy, move_speed_effect)


func on_enemy_pre_stunned(enemy: Enemy, stun_effect: StunEffect) -> void:
	for condition in get_player_conditions():
		condition.on_enemy_pre_stunned(enemy, stun_effect)


func on_enemy_stunned(enemy: Enemy) -> void:
	for condition in get_player_conditions():
		condition.on_enemy_stunned(enemy)


func on_enemy_hit(bullet: Bullet, enemy: Enemy) -> void:
	for condition in get_player_conditions():
		condition.on_enemy_hit(bullet, enemy)


func on_enemy_received_damage(bullet: Bullet, enemy: Enemy) -> void:
	for condition in get_player_conditions():
		condition.on_enemy_received_damage(bullet, enemy)


func on_player_received_damage() -> void:
	for condition in get_player_conditions():
		condition.on_player_received_damage()


#endregion


func get_player_conditions() -> Array[Condition]:
	if Globals.player != null:
		return Globals.player.conditions
	return []
