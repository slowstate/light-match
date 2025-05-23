class_name BulletUpgradeManager
extends Node

var upgrade1 = Upgrade.new()
var upgrades := [Callable(upgrade1.do())]


# BulletUpgradeManager
func apply_upgrades(bullet: Bullet) -> Bullet:
	var upgraded_bullet: Bullet
	upgraded_bullet = apply_colour_effects(bullet)

	return upgraded_bullet


func apply_colour_effects(bullet: Bullet) -> Bullet:
	pass
