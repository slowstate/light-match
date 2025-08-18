class_name Condition
extends Resource

var name: String
var description: String
var added_dialogue: String
var points_per_round: int = 1


#region Utils
func new_timer() -> Timer:
	var timer = Timer.new()
	timer.one_shot = true
	Globals.player.add_child(timer)
	return timer


#endregion


#region
func on_condition_added(_condition: Condition) -> void:
	pass


func on_palette_failed(_player: Player) -> void:
	pass


func on_round_loaded(_round: Round) -> void:
	pass


func on_enemy_spawned(_enemy: Enemy) -> void:
	pass


func on_enemy_pre_slowed(_enemy: Enemy, _move_speed_effect: MoveSpeedEffect) -> void:
	pass


func on_enemy_slowed(_enemy: Enemy, _move_speed_effect: MoveSpeedEffect) -> void:
	pass


func on_enemy_pre_stunned(_enemy: Enemy, _stun_effect: StunEffect) -> void:
	pass


func on_enemy_stunned(_enemy: Enemy) -> void:
	pass


func on_enemy_hit(_bullet: Bullet, _enemy: Enemy) -> void:
	pass


func on_enemy_received_damage(_bullet: Bullet, _enemy: Enemy) -> void:
	pass


func on_player_received_damage() -> void:
	pass

#endregion
