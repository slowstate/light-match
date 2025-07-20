class_name StarStateTeleport
extends State

var star: Star

var prep_time: float = randf_range(1.5, 2.5)
var charge_shell_rotation_speed: float
var target_location: Vector2
var cooldown_time: float = 2.0

@onready var prep_timer: Timer = $PrepTimer
@onready var cooldown_timer: Timer = $CooldownTimer


func enter() -> void:
	star = owner as Star
	assert(star != null, "The state type must be used only in the Star scene. It needs the owner to be a Star node.")
	star.hit_box.modulate.a = 0.0
	charge_shell_rotation_speed = star.shell_rotation_speed * 100.0
	target_location = star.global_position + (Globals.player.global_position - star.global_position).limit_length(500.0)
	target_location.x += randf_range(-100.0, 100.0)
	target_location.y += randf_range(-100.0, 100.0)
	target_location = target_location.clamp(Vector2(40, 40), Vector2(3800, 2120))
	star.hit_box.global_position = target_location
	if !prep_timer.timeout.is_connected(_on_prep_timer_timeout):
		prep_timer.timeout.connect(_on_prep_timer_timeout)
	if !cooldown_timer.timeout.is_connected(_on_cooldown_timer_timeout):
		cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	prep_timer.start(prep_time)


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !star:
		return
	if !Globals.player:
		return

	if !prep_timer.is_stopped():
		star.hit_box.modulate.a = lerpf(0.0, 1.0, ease(1 - prep_timer.time_left / prep_timer.wait_time, 0.5))
		star.hit_box.modulate.g = lerpf(1.0, 0.0, ease(1 - prep_timer.time_left / prep_timer.wait_time, 0.5))
	if !cooldown_timer.is_stopped():
		charge_shell_rotation_speed = lerpf(
			star.shell_rotation_speed * 100.0, star.shell_rotation_speed, ease(1 - cooldown_timer.time_left / cooldown_timer.wait_time, 0.5)
		)
	star.rotate_star(delta, charge_shell_rotation_speed)


func _on_prep_timer_timeout() -> void:
	star.hit_box.modulate.a = 0.0
	if star.hit_box.get_overlapping_areas().size() > 0:
		Globals.player.player_hit(star)
	star.global_position = target_location
	cooldown_timer.start(cooldown_time)


func _on_cooldown_timer_timeout() -> void:
	transition.emit("Idle")
