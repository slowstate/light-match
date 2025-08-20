extends Upgrade

const MOVE_SPEED_EFFECT = preload("res://Common/StatusEffects/MoveSpeedEffect/move_speed_effect.tscn")

var effect_timer: Timer
var slow_amount: float = 0.3
var slow_duration: float = 3.0
var effect_duration: float = 10.0


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.TASER
	name = tr("CONDITION_TASER_NAME")
	description = tr("CONDITION_TASER_DESCRIPTION")
	added_dialogue = tr("CONDITION_TASER_DIALOGUE")
	icon = preload("res://Player/Upgrades/Utility/Taser.png")
	points_cost = 0
	effect_timer = super.new_timer()
	effect_timer.connect("timeout", _on_effect_timer_timeout)


func on_palette_cleared(_palette: Palette) -> void:
	is_active = true
	Globals.player.enable_taser_particles(true)
	effect_timer.start(effect_duration)
	SfxManager.play_sound("TaserActiveSFX", -20.0, -18.0, 0.9, 1.0)


func _on_effect_timer_timeout() -> void:
	is_active = false
	Globals.player.enable_taser_particles(false)


func on_enemy_hit(bullet: Bullet, enemy: Enemy = null) -> void:
	if is_active:
		var move_speed_effect = MOVE_SPEED_EFFECT.instantiate()
		move_speed_effect.effect_amount = -slow_amount
		move_speed_effect.effect_duration = slow_duration + Save.lifetime_palettes * 0.01
		enemy.add_child(move_speed_effect)
