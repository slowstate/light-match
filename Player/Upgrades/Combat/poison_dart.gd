extends Upgrade

var palettes_cleared_in_a_row: int = 0
var active_bullet_id: String
var effect_timer: Timer


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.POSION_DART
	name = "Poison Dart"
	description = "After clearing 2 palettes, your bullets reduce the enemy's HP to 1 for 10s"
	icon = preload("res://Player/Upgrades/Combat/Poison Dart.png")
	effect_timer = super.new_timer()
	effect_timer.connect("timeout", _on_effect_timer_timeout)
	points_cost = 1


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_palette_cleared(_palette: Palette) -> void:
	palettes_cleared_in_a_row += 1
	if palettes_cleared_in_a_row >= 2:
		effect_timer.start(10)
		is_active = true
		palettes_cleared_in_a_row = 0
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_palette_failed() -> void:
	palettes_cleared_in_a_row = 0
	upgrade_counter_updated.emit(palettes_cleared_in_a_row)


func on_bullet_fired(bullet: Bullet) -> void:
	if effect_timer.is_stopped():
		active_bullet_id = bullet.bullet_id


func on_enemy_hit(bullet: Bullet, enemy: Enemy = null):
	if bullet.bullet_id == active_bullet_id:
		bullet.damage = maxi(enemy.health - 1, 1)


func _on_effect_timer_timeout() -> void:
	is_active = false
