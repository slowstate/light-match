class_name Upgrade
extends Resource

var type: UpgradeManager.UpgradeTypes
var name: String
var description: String


#region Util
func new_timer() -> Timer:
	var new_timer = Timer.new()
	new_timer.one_shot = true
	Globals.player.add_child(new_timer)
	return new_timer


#endregion


#region Triggers
func on_gun_colour_switch(gun_cooldown_timer: Timer) -> Timer:
	return gun_cooldown_timer


func on_gun_cooldown_start(gun_cooldown_timer: Timer) -> Timer:
	return gun_cooldown_timer


func on_enemy_spawned(enemy: Enemy) -> Enemy:
	return enemy


func on_enemy_killed(enemy: Enemy) -> Enemy:
	return enemy


func on_palette_generated() -> void:
	pass


func on_palette_cleared() -> void:
	pass


func on_palette_failed() -> void:
	pass


func on_player_moving() -> void:
	pass


func on_bullet_travelled_x_pixels(bullet: Bullet, _x: int) -> Bullet:
	return bullet


func on_enemy_hit(bullet: Bullet, _enemy: Enemy = null) -> Bullet:
	return bullet


func on_bullet_fired(bullet: Bullet) -> Bullet:
	return bullet


func on_upgrade_removed(_removed_upgrade: Upgrade) -> void:
	pass
#endregion
