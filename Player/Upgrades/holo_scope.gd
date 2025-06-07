extends Upgrade


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.HOLO_SCOPE
	name = "Holo Scope"
	description = "Deal 1 bonus damage to enemies more than 500 pixels away"  # TODO: Reword "pixels"


func on_bullet_travelled_x_pixels(bullet: Bullet, x: int) -> Bullet:
	if bullet.travel_distance >= x:
		bullet.damage += 1
	return bullet
