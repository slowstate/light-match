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
	SHOCK_BATON,
	PANIC_BOOSTER,
	ADRENALINE_INJECTION,
	ENERGY_COLLECTOR,
	TASER,
	_3D_PRINTER,
	_4D_GLASSES,
	COLOUR_CHANGING_DYE,
	#KALEIDOSCOPE,
	LUCKY_DICE,
	PAINTBALL_GUN,
	PAINT_BOMB,
	SILVER_SPOON,
	SPRAY_PAINT,
	#STOPWATCH,
}

#region Combat upgrades
const BiggerBullet = preload("res://Player/Upgrades/Combat/bigger_bullet.gd")
const BigBullet = preload("res://Player/Upgrades/Combat/big_bullet.gd")
const Bipod = preload("res://Player/Upgrades/Combat/bipod.gd")
const ChargedAmmo = preload("res://Player/Upgrades/Combat/charged_ammo.gd")
const ChromeKnuckles = preload("res://Player/Upgrades/Combat/chrome_knuckles.gd")
const HoloScope = preload("res://Player/Upgrades/Combat/holo_scope.gd")
const PoisonDart = preload("res://Player/Upgrades/Combat/poison_dart.gd")
const QuickReleaseMag = preload("res://Player/Upgrades/Combat/quick_release_mag.gd")
const RevolverBarrel = preload("res://Player/Upgrades/Combat/revolver_barrel.gd")
const RoseTintedGlasses = preload("res://Player/Upgrades/Combat/rose_tinted_glasses.gd")
#endregion

#region Utility upgrades
const AdrenalineInjection = preload("res://Player/Upgrades/Utility/adrenaline_injection.gd")
const BionicLegs = preload("res://Player/Upgrades/Utility/bionic_legs.gd")
const EnergyCollector = preload("res://Player/Upgrades/Utility/energy_collector.gd")
const FreezeBomb = preload("res://Player/Upgrades/Utility/freeze_bomb.gd")
const PanicBooster = preload("res://Player/Upgrades/Utility/panic_booster.gd")
const PowerDiverter = preload("res://Player/Upgrades/Utility/power_diverter.gd")
const RepulsorField = preload("res://Player/Upgrades/Utility/repulsor_field.gd")
const ShieldGenerator = preload("res://Player/Upgrades/Utility/shield_generator.gd")
const ShockBaton = preload("res://Player/Upgrades/Utility/shock_baton.gd")
const Taser = preload("res://Player/Upgrades/Utility/taser.gd")
#endregion

#region Meta upgrades
const _3dPrinter = preload("res://Player/Upgrades/Meta/3d_printer.gd")
const _4dGlasses = preload("res://Player/Upgrades/Meta/4d_glasses.gd")
const ColourChangingDye = preload("res://Player/Upgrades/Meta/colour_changing_dye.gd")
const Kaleidoscope = preload("res://Player/Upgrades/Meta/kaleidoscope.gd")
const LuckyDice = preload("res://Player/Upgrades/Meta/lucky_dice.gd")
const PaintballGun = preload("res://Player/Upgrades/Meta/paintball_gun.gd")
const PaintBomb = preload("res://Player/Upgrades/Meta/paint_bomb.gd")
const SilverSpoon = preload("res://Player/Upgrades/Meta/silver_spoon.gd")
const SprayPaint = preload("res://Player/Upgrades/Meta/spray_paint.gd")
const Stopwatch = preload("res://Player/Upgrades/Meta/stopwatch.gd")
#endregion

const ALL_UPGRADES: Dictionary = {
	UpgradeTypes.BIGGER_BULLET: BiggerBullet,
	UpgradeTypes.BIG_BULLET: BigBullet,
	UpgradeTypes.BIPOD: Bipod,
	UpgradeTypes.CHARGED_AMMO: ChargedAmmo,
	UpgradeTypes.CHROME_KNUCKLES: ChromeKnuckles,
	UpgradeTypes.HOLO_SCOPE: HoloScope,
	UpgradeTypes.POSION_DART: PoisonDart,
	UpgradeTypes.QUICK_RELEASE_MAG: QuickReleaseMag,
	UpgradeTypes.REVOLVER_BARREL: RevolverBarrel,
	UpgradeTypes.ROSE_TINTED_GLASSES: RoseTintedGlasses,
	UpgradeTypes.ADRENALINE_INJECTION: AdrenalineInjection,
	UpgradeTypes.BIONIC_LEGS: BionicLegs,
	UpgradeTypes.ENERGY_COLLECTOR: EnergyCollector,
	UpgradeTypes.FREEZE_BOMB: FreezeBomb,
	UpgradeTypes.PANIC_BOOSTER: PanicBooster,
	UpgradeTypes.POWER_DIVERTER: PowerDiverter,
	UpgradeTypes.REPULSOR_FIELD: RepulsorField,
	UpgradeTypes.SHIELD_GENERATOR: ShieldGenerator,
	UpgradeTypes.SHOCK_BATON: ShockBaton,
	UpgradeTypes.TASER: Taser,
	UpgradeTypes._3D_PRINTER: _3dPrinter,
	UpgradeTypes._4D_GLASSES: _4dGlasses,
	UpgradeTypes.COLOUR_CHANGING_DYE: ColourChangingDye,
	#UpgradeTypes.KALEIDOSCOPE: Kaleidoscope,
	UpgradeTypes.LUCKY_DICE: LuckyDice,
	UpgradeTypes.PAINTBALL_GUN: PaintballGun,
	UpgradeTypes.PAINT_BOMB: PaintBomb,
	UpgradeTypes.SILVER_SPOON: SilverSpoon,
	UpgradeTypes.SPRAY_PAINT: SprayPaint,
	#UpgradeTypes.STOPWATCH: Stopwatch,
}


#region
func on_gun_colour_switch(gun_cooldown_timer: Timer) -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_gun_colour_switch(gun_cooldown_timer)


func on_gun_cooldown_start(gun_cooldown_timer: Timer) -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_gun_cooldown_start(gun_cooldown_timer)


func on_enemy_spawned(enemy: Enemy) -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_enemy_spawned(enemy)


func on_enemy_killed(enemy: Enemy) -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_enemy_killed(enemy)


func on_palette_generated() -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_palette_generated()


func on_palette_cleared(palette: Palette) -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_palette_cleared(palette)


func on_palette_failed() -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_palette_failed()


func on_player_moving(is_moving: bool) -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_player_moving(is_moving)


func on_player_shield_break() -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_player_shield_break()


func on_player_hit() -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_player_hit()


func on_bullet_travelled_x_pixels(bullet: Bullet, x: float) -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_bullet_travelled_x_pixels(bullet, x)


func on_enemy_hit(bullet: Bullet, enemy: Enemy = null) -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_enemy_hit(bullet, enemy)


func on_bullet_fired(bullet: Bullet) -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_bullet_fired(bullet)


func on_bullet_hit(bullet: Bullet) -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_bullet_hit(bullet)


func on_upgrade_added(new_upgrade: Upgrade) -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_upgrade_added(new_upgrade)


func on_upgrade_removed(removed_upgrade: Upgrade) -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_upgrade_removed(removed_upgrade)


func on_get_pickable_upgrades(pickable_upgrades: Array[UpgradeManager.UpgradeTypes]) -> void:
	for upgrade in get_player_upgrades():
		upgrade.on_get_pickable_upgrades(pickable_upgrades)


#endregion


func get_pickable_upgrades() -> Array[UpgradeTypes]:
	var pickable_upgrades: Array[UpgradeTypes]
	var current_player_upgrades: Array[UpgradeTypes]
	for upgrade in Globals.player.upgrades:
		current_player_upgrades.push_back(upgrade.type)

	for upgrade_type in UpgradeTypes.values():
		if !current_player_upgrades.has(upgrade_type):
			pickable_upgrades.push_back(upgrade_type)
	UpgradeManager.on_get_pickable_upgrades(pickable_upgrades)

	return pickable_upgrades


func get_player_upgrades() -> Array[Upgrade]:
	if Globals.player != null:
		return Globals.player.upgrades
	return []
