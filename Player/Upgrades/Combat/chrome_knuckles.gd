extends Upgrade


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.CHROME_KNUCKLES
	name = "Chrome Knuckles"
	description = "While there are at least 3 enemies within 300 pixels of you, gain a 50% chance to deal 1 more damage"


func on_bullet_fired(bullet: Bullet) -> void:
	if Globals.player.chrome_knuckles_proximity.get_overlapping_areas().size() >= 3:
		bullet.damage += randi_range(0, 1)
