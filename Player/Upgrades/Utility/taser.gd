extends Upgrade

var effect_timers: Array[Timer]
var slowed_enemies: Array[Enemy]


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.TASER
	name = "Taser"
	description = "Enemies hit by a different colour have their move speed reduced by 50% for 3s"
	icon = preload("res://Player/Upgrades/Utility/Taser.png")


func on_upgrade_added(new_upgrade: Upgrade) -> void:
	if new_upgrade == self:
		is_active = true


func on_enemy_hit(bullet: Bullet, enemy: Enemy = null) -> void:
	if bullet.colour != enemy.colour:
		slowed_enemies.push_back(enemy)
		var effect_timer = super.new_timer()
		effect_timer.connect("timeout", _on_effect_timer_timeout)
		effect_timer.start(3)
		effect_timers.push_back(effect_timer)
		enemy.move_speed *= 0.5
		ConditionManager.on_enemy_slowed(enemy)


func on_enemy_killed(enemy: Enemy) -> void:
	var enemy_index = slowed_enemies.find(enemy)
	if enemy_index >= 0:
		var effect_timer = effect_timers.pop_at(enemy_index)
		effect_timer.queue_free()
		slowed_enemies.erase(enemy)


func _on_effect_timer_timeout() -> void:
	if slowed_enemies.is_empty():
		return
	var slowed_enemy = slowed_enemies.pop_front()
	if is_instance_valid(slowed_enemy):
		slowed_enemy = slowed_enemy as Enemy
		slowed_enemy.move_speed /= 0.5
	var effect_timer = effect_timers.pop_front() as Timer
	effect_timer.queue_free()


func on_upgrade_removed(removed_upgrade: Upgrade) -> void:
	if removed_upgrade == self:
		for enemy in slowed_enemies:
			enemy.move_speed /= 0.5
