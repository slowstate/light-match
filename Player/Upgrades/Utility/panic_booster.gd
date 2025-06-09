extends Upgrade

var effect_timer: Timer
var effect_duration: float = 3.0
var original_hit_immunity_time: float = 1.0


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	type = UpgradeManager.UpgradeTypes.PANIC_BOOSTER
	name = "Panic Booster"
	description = "After being hit, gain 30% move speed and hit immunity for 3s"
	effect_timer = super.new_timer()
	effect_timer.connect("timeout", _on_effect_timer_timeout)


func on_player_hit() -> void:
	Globals.player.move_speed *= 1.3
	original_hit_immunity_time = Globals.player.hit_immunity_time
	Globals.player.hit_immunity_time = effect_duration
	effect_timer.start(effect_duration)


func _on_effect_timer_timeout() -> void:
	Globals.player.move_speed /= 1.3
	Globals.player.hit_immunity_time = original_hit_immunity_time


func on_upgrade_removed(removed_upgrade: Upgrade) -> void:
	if removed_upgrade == self and !effect_timer.is_stopped():
		Globals.player.move_speed /= 1.3
		Globals.player.hit_immunity_time = original_hit_immunity_time
