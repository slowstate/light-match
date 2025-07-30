extends Upgrade

const MOVE_SPEED_EFFECT = preload("res://Common/StatusEffects/MoveSpeedEffect/move_speed_effect.tscn")

var slow_amount: float = 0.5
var effect_duration: float = 3.0


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.TASER
	name = "Taser"
	description = "When you hit an enemy with a different colour, slow it by " + str(slow_amount * 100) + "% for " + str(effect_duration) + "s"
	icon = preload("res://Player/Upgrades/Utility/Taser.png")
	points_cost = 3


func on_upgrade_added(new_upgrade: Upgrade) -> void:
	if new_upgrade == self:
		is_active = true


func on_enemy_hit(bullet: Bullet, enemy: Enemy = null) -> void:
	if bullet.colour != enemy.colour:
		var move_speed_effect = MOVE_SPEED_EFFECT.instantiate()
		move_speed_effect.effect_amount = -slow_amount
		move_speed_effect.effect_duration = effect_duration
		enemy.add_child(move_speed_effect)
