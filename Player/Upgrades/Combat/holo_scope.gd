extends Upgrade

var bullet_travel_distances: Dictionary


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.HOLO_SCOPE
	name = "Holo Scope"
	description = "Deal 1 bonus damage to enemies that are faraway"


func on_bullet_travelled_x_pixels(bullet: Bullet, x: float) -> void:
	bullet_travel_distances.get_or_add(bullet, 0)
	bullet_travel_distances[bullet] += x


func on_enemy_hit(bullet: Bullet, enemy: Enemy = null) -> void:
	if bullet_travel_distances[bullet] >= 500.0:
		bullet.damage += 1


func on_bullet_hit(bullet: Bullet) -> void:
	bullet_travel_distances.erase(bullet)
