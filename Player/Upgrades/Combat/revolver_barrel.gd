extends Upgrade

@warning_ignore("enum_variable_without_default")
var last_killed_colour: Globals.Colour
var number_of_same_colour_kills_in_a_row: int = 0
var effect_timer: Timer


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.REVOLVER_BARREL
	name = "Revolver Barrel"
	description = "After killing 2 enemies of the same colour in a row, your bullets deals 1 more damage for 5s"
	icon = preload("res://Player/Upgrades/Combat/Revolver Barrel.png")
	effect_timer = super.new_timer()
	effect_timer.connect("timeout", _on_effect_timer_timeout)


func trigger_counter_update() -> void:
	upgrade_counter_updated.emit(number_of_same_colour_kills_in_a_row)


func on_enemy_killed(enemy: Enemy) -> void:
	if enemy.colour != last_killed_colour:
		number_of_same_colour_kills_in_a_row = 0
	last_killed_colour = enemy.colour
	number_of_same_colour_kills_in_a_row += 1
	if number_of_same_colour_kills_in_a_row >= 2:
		effect_timer.start(5)
		is_active = true
	upgrade_counter_updated.emit(number_of_same_colour_kills_in_a_row)


func on_bullet_fired(bullet: Bullet) -> void:
	if !effect_timer.is_stopped():
		bullet.damage += 1


func _on_effect_timer_timeout() -> void:
	is_active = false
