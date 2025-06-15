class_name Upgrade
extends Resource

@warning_ignore("unused_signal")
signal upgrade_counter_updated(counter: int)

var type: UpgradeManager.UpgradeTypes
var name: String
var description: String
var icon


#region Util
func new_timer() -> Timer:
	var timer = Timer.new()
	timer.one_shot = true
	Globals.player.add_child(timer)
	return timer


func trigger_counter_update() -> void:
	pass


#endregion


#region Triggers
func on_gun_colour_switch(_gun_cooldown_timer: Timer) -> void:
	pass


func on_gun_cooldown_start(_gun_cooldown_timer: Timer) -> void:
	pass


func on_enemy_spawned(_enemy: Enemy) -> void:
	pass


func on_enemy_appendage_hit(_bullet: Bullet, _appendage: Appendage) -> void:
	pass


func on_enemy_colour_changed() -> void:
	pass


func on_enemy_killed(_enemy: Enemy) -> void:
	pass


func on_palette_generated() -> void:
	pass


func on_palette_cleared(_palette: Palette) -> void:
	pass


func on_palette_failed() -> void:
	pass


func on_player_moving(_is_moving: bool) -> void:
	pass


func on_player_shield_break() -> void:
	pass


func on_player_hit() -> void:
	pass


func on_bullet_travelled_x_pixels(_bullet: Bullet, _x: float) -> void:
	pass


func on_enemy_hit(_bullet: Bullet, _enemy: Enemy = null) -> void:
	pass


func on_bullet_fired(_bullet: Bullet) -> void:
	pass


func on_bullet_hit(_bullet: Bullet) -> void:
	pass


func on_upgrade_added(_new_upgrade: Upgrade) -> void:
	pass


func on_upgrade_removed(_removed_upgrade: Upgrade) -> void:
	pass


func on_get_pickable_upgrades(_pickable_upgrades: Array[UpgradeManager.UpgradeTypes]) -> void:
	pass
#endregion
