extends Upgrade


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.CHROME_KNUCKLES
	name = "Chrome Knuckles"
	description = "While there are at least 3 enemies within 400 pixels of you, your bullets deal 1 more damage"
	icon = preload("res://Player/Upgrades/Combat/Chrome Knuckles.png")


func on_upgrade_added(new_upgrade: Upgrade) -> void:
	if new_upgrade == self:
		Globals.player.chrome_knuckles_proximity.visible = true


func on_bullet_fired(bullet: Bullet) -> void:
	if is_active:
		bullet.damage += 1


func on_upgrade_removed(removed_upgrade: Upgrade) -> void:
	if removed_upgrade == self:
		Globals.player.chrome_knuckles_proximity.visible = false
