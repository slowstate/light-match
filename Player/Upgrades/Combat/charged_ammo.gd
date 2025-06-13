extends Upgrade


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.CHARGED_AMMO
	name = "Charged Ammo"
	description = "While your gun colour is the same colour as the last colour on your palette, you deal 2 more damage"
	icon = preload("res://Player/Upgrades/Combat/Charged Ammo.png")


func on_bullet_fired(bullet: Bullet) -> void:
	var player_palette = Globals.player.palette.palette_colours
	if player_palette.is_empty():
		return
	if bullet.colour == player_palette.back():
		bullet.damage += 2
