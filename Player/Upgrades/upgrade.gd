class_name Upgrade
extends Resource

signal upgrade_counter_updated(counter: int)

var type: UpgradeManager.UpgradeTypes
var name: String
var description: String


#region Util
func new_timer() -> Timer:
	var new_timer = Timer.new()
	new_timer.one_shot = true
	Globals.player.add_child(new_timer)
	return new_timer


func trigger_counter_update() -> void:
	pass


#endregion


#region Triggers
func on_gun_colour_switch(gun_cooldown_timer: Timer) -> void:
	pass


func on_gun_cooldown_start(gun_cooldown_timer: Timer) -> void:
	pass


func on_enemy_spawned(enemy: Enemy) -> void:
	pass


func on_enemy_killed(enemy: Enemy) -> void:
	pass


func on_palette_generated() -> void:
	pass


func on_palette_cleared(palette: Palette) -> void:
	pass


func on_palette_failed() -> void:
	pass


func on_player_moving(_is_moving: bool) -> void:
	pass


func on_player_hit() -> void:
	pass


func on_bullet_travelled_x_pixels(bullet: Bullet, _x: float) -> void:
	pass


func on_enemy_hit(bullet: Bullet, _enemy: Enemy = null) -> void:
	pass


func on_bullet_fired(bullet: Bullet) -> void:
	pass


func on_bullet_hit(bullet: Bullet) -> void:
	pass


func on_upgrade_added(_new_upgrade: Upgrade) -> void:
	pass


func on_upgrade_removed(_removed_upgrade: Upgrade) -> void:
	pass


func on_get_pickable_upgrades(_pickable_upgrades: Array[UpgradeManager.UpgradeTypes]) -> void:
	pass
#endregion
