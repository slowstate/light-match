extends Node

enum UpgradeTypes {
	BIG_BULLET,
	CHARGED_AMMO,
	QUICK_RELEASE_MAG,
	BIPOD,
	HOLO_SCOPE,
	BIGGER_BULLET,
	POSION_DART,
	ROSE_TINTED_GLASSES,
	CHROME_KNUCKLES,
	REVOLVER_BARREL,
	SHIELD_GENERATOR,
	BIONIC_LEGS,
	FREEZE_BOMB,
	POWER_DIVERTER,
	REPULSOR_FIELD,
}

const BigBullet = preload("res://Player/Upgrades/big_bullet.gd")
const ChargedAmmo = preload("res://Player/Upgrades/charged_ammo.gd")
const QuickReleaseMag = preload("res://Player/Upgrades/quick_release_mag.gd")
const Bipod = preload("res://Player/Upgrades/bipod.gd")
const HoloScope = preload("res://Player/Upgrades/holo_scope.gd")
const BiggerBullet = preload("res://Player/Upgrades/bigger_bullet.gd")
const PoisonDart = preload("res://Player/Upgrades/poison_dart.gd")
const RoseTintedGlasses = preload("res://Player/Upgrades/rose_tinted_glasses.gd")
const ChromeKnuckles = preload("res://Player/Upgrades/chrome_knuckles.gd")
const RevolverBarrel = preload("res://Player/Upgrades/revolver_barrel.gd")
const ShieldGenerator = preload("res://Player/Upgrades/shield_generator.gd")
const BionicLegs = preload("res://Player/Upgrades/bionic_legs.gd")
const FreezeBomb = preload("res://Player/Upgrades/freeze_bomb.gd")
const PowerDiverter = preload("res://Player/Upgrades/power_diverter.gd")
const RepulsorField = preload("res://Player/Upgrades/repulsor_field.gd")

const ALL_UPGRADES: Dictionary = {
	UpgradeTypes.BIG_BULLET: BigBullet,
	UpgradeTypes.CHARGED_AMMO: ChargedAmmo,
	UpgradeTypes.QUICK_RELEASE_MAG: QuickReleaseMag,
	UpgradeTypes.BIPOD: Bipod,
	UpgradeTypes.HOLO_SCOPE: HoloScope,
	UpgradeTypes.BIGGER_BULLET: BiggerBullet,
	UpgradeTypes.POSION_DART: PoisonDart,
	UpgradeTypes.ROSE_TINTED_GLASSES: RoseTintedGlasses,
	UpgradeTypes.CHROME_KNUCKLES: ChromeKnuckles,
	UpgradeTypes.REVOLVER_BARREL: RevolverBarrel,
	UpgradeTypes.SHIELD_GENERATOR: ShieldGenerator,
	UpgradeTypes.BIONIC_LEGS: BionicLegs,
	UpgradeTypes.FREEZE_BOMB: FreezeBomb,
	UpgradeTypes.POWER_DIVERTER: PowerDiverter,
	UpgradeTypes.REPULSOR_FIELD: RepulsorField,
}


#region
static func on_gun_colour_switch(gun_cooldown_timer: Timer) -> Timer:
	for upgrade in get_player_upgrades():
		gun_cooldown_timer = upgrade.on_gun_colour_switch(gun_cooldown_timer)
	return gun_cooldown_timer


static func on_gun_cooldown_start(gun_cooldown_timer: Timer) -> Timer:
	for upgrade in get_player_upgrades():
		gun_cooldown_timer = upgrade.on_gun_cooldown_start(gun_cooldown_timer)
	return gun_cooldown_timer


static func on_enemy_spawned(enemy: Enemy) -> Enemy:
	for upgrade in get_player_upgrades():
		enemy = upgrade.on_enemy_spawned(enemy)
	return enemy


static func on_enemy_killed(enemy: Enemy) -> Enemy:
	for upgrade in get_player_upgrades():
		enemy = upgrade.on_enemy_killed(enemy)
	return enemy


static func on_palette_generated() -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_palette_generated()


static func on_palette_cleared() -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_palette_cleared()


static func on_palette_failed() -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_palette_failed()


static func on_player_moving() -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_player_moving()


static func on_bullet_travelled_x_pixels(bullet: Bullet, x: int) -> Bullet:
	for upgrade in get_player_upgrades():
		bullet = upgrade.on_bullet_travelled_x_pixels(bullet, x)
	return bullet


static func on_enemy_hit(bullet: Bullet, enemy: Enemy = null) -> Bullet:
	for upgrade in get_player_upgrades():
		bullet = upgrade.on_enemy_hit(bullet, enemy)
	return bullet


static func on_bullet_fired(bullet: Bullet) -> Bullet:
	for upgrade in get_player_upgrades():
		bullet = upgrade.on_bullet_fired(bullet)
	return bullet


static func on_upgrade_removed(removed_upgrade: Upgrade) -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_upgrade_removed(removed_upgrade)


#endregion


static func get_player_upgrades() -> Array[Upgrade]:
	if Globals.player != null:
		return Globals.player.upgrades
	return []
