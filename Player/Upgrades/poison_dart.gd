extends Upgrade

var palettes_cleared_in_a_row: int
var is_active: bool
var active_bullet_id: String


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.POSION_DART
	name = "Poison Dart"
	description = "After clearing 2 palettes in a row, your next bullet reduces the enemy's HP to 1"


func on_palette_cleared() -> void:
	palettes_cleared_in_a_row += 1
	if palettes_cleared_in_a_row >= 2:
		is_active = true
		palettes_cleared_in_a_row = 0


func on_palette_failed() -> void:
	palettes_cleared_in_a_row = 0


func on_bullet_fired(bullet: Bullet) -> Bullet:
	if is_active:
		active_bullet_id = bullet.bullet_id
		is_active = false
	return bullet


func on_enemy_hit(bullet: Bullet, enemy: Enemy = null) -> Bullet:
	if bullet.bullet_id == active_bullet_id:
		bullet.damage = enemy.health - 1
	return bullet
