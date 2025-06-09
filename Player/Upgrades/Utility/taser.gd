extends Upgrade

var effect_timers: Array[Timer]
var slowed_enemies: Array[Enemy]


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.TASER
	name = "Taser"
	description = "Enemies hit by a different colour have their move speed reduced by 20% for 1s"


func on_enemy_hit(bullet: Bullet, enemy: Enemy = null) -> void:
	if bullet.colour != enemy.colour:
		slowed_enemies.push_back(enemy)
		var effect_timer = super.new_timer()
		effect_timer.connect("timeout", _on_effect_timer_timeout)
		effect_timer.start(1)
		effect_timers.push_back(effect_timer)
		enemy.move_speed *= 0.5


func on_enemy_killed(enemy: Enemy) -> void:
	var enemy_index = slowed_enemies.find(enemy)
	if enemy_index >= 0:
		var effect_timer = effect_timers.pop_at(enemy_index)
		effect_timer.queue_free()
		slowed_enemies.erase(enemy)


func _on_effect_timer_timeout() -> void:
	var slowed_enemy = slowed_enemies.pop_front() as Enemy
	slowed_enemy.move_speed /= 0.5
	var effect_timer = effect_timers.pop_front() as Timer
	effect_timer.queue_free()


func on_upgrade_removed(removed_upgrade: Upgrade) -> void:
	if removed_upgrade == self:
		for enemy in slowed_enemies:
			enemy.move_speed /= 0.5
