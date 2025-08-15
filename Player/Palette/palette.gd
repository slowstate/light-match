class_name Palette
extends Node2D

const PALETTE_COLOUR = preload("res://Player/Palette/palette_colour.tscn")
const PALETTE_PARTICLES = preload("res://Player/Palette/palette_particles.tscn")

var palette_colours: Array[Globals.Colour]
var current_palette_colour_index: int = 0
var palette_size: int = 3
var palette_can_fail: bool = true
var timer_progress: float = 0.0
var reload_time: float = 1.0
var reload_animation_progress: float = 0.0
var grace_period_time: float = 0.5
var palette_lockout: float = 3.0

@onready var palette_colour_sprites: HBoxContainer = $PaletteColourSprites
@onready var reload_timer: Timer = $ReloadTimer
@onready var grace_period_timer: Timer = $GracePeriodTimer
@onready var failed_cooldown_timer: Timer = $FailedCooldownTimer
@onready var palette_completed_overlay: Sprite2D = $PaletteCompletedOverlay/PaletteCompletedOverlay


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("enemy_died", _on_enemy_died)


func _process(delta: float) -> void:
	if !reload_timer.is_stopped():
		palette_colour_sprites.add_theme_constant_override("separation", lerp(36, 0, ease((1 - reload_timer.time_left / reload_timer.wait_time) * 1.5, 0.5)))
		reload_animation_progress = 0.0
	else:
		reload_animation_progress += delta
		var separation = palette_colour_sprites.get_theme_constant("separation")
		palette_colour_sprites.add_theme_constant_override("separation", lerp(separation, 36, reload_animation_progress / 0.1))

	if !failed_cooldown_timer.is_stopped():
		timer_progress += delta * 2
		for palette_colour_sprite in palette_colour_sprites.get_children():
			palette_colour_sprite.update_shader_timer_progress(clamp(timer_progress, 0.0, 1.0))

	if palette_completed_overlay.modulate.a > 0.0:
		palette_completed_overlay.modulate.a = lerp(palette_completed_overlay.modulate.a, 0.0, delta / 0.2)


func _on_enemy_died(enemy: Enemy) -> void:
	if enemy == null:
		return

	if !failed_cooldown_timer.is_stopped() or !reload_timer.is_stopped():
		return

	if enemy.colour != palette_colours[current_palette_colour_index]:
		if grace_period_timer.is_stopped() and palette_can_fail:
			on_palette_failed()
		return

	var palette_particles = PALETTE_PARTICLES.instantiate()
	palette_particles.modulate = Globals.COLOUR_VISUAL_VALUE[palette_colours[current_palette_colour_index]]
	palette_particles.global_position = (palette_colour_sprites.get_children()[current_palette_colour_index] as Control).global_position + Vector2(0, -32)
	palette_particles.emitting = true
	get_tree().root.add_child(palette_particles)

	if current_palette_colour_index >= palette_colours.size() - 1:
		on_palette_cleared(enemy)
		return

	palette_colour_sprites.get_children()[current_palette_colour_index].visible = false
	current_palette_colour_index += 1
	palette_colour_sprites.get_children()[current_palette_colour_index].update_shader_alpha(1.0)
	SfxManager.play_sound("PaletteSuccessSFX", -17.0, -15.0, 1.0, 1.0)


func reload_palette() -> void:
	if !failed_cooldown_timer.is_stopped() or !reload_timer.is_stopped():
		return

	for palette_colour in palette_colour_sprites.get_children():
		palette_colour.update_shader_modulate(Color(1.0, 1.0, 1.0, 1.0))
		palette_colour.update_shader_alpha(0.4)
	reload_timer.start(reload_time)
	SfxManager.play_sound("PaletteReloadSFX", -15.0, -13.0, 0.90, 1.0)

func _on_reload_timer_timeout() -> void:
	generate_new_palette()


func on_palette_failed() -> void:
	UpgradeManager.on_palette_failed()
	if !failed_cooldown_timer.is_stopped():
		return
	for palette_colour in palette_colour_sprites.get_children():
		palette_colour.update_shader_modulate(Color(1.0, 1.0, 1.0, 1.0))
		palette_colour.update_shader_alpha(0.4)
	timer_progress = 0.0
	failed_cooldown_timer.start(palette_lockout)
	SfxManager.play_sound("PaletteFailSFX", -17.0, -15.0, 1.0, 1.0)
	for palette_colour_sprite in palette_colour_sprites.get_children():
		palette_colour_sprite.update_shader_rand(randf_range(-1.0, 1.0))

	var palette_colours_strings = []
	for palette_colour in palette_colours:
		palette_colours_strings.append(Globals.COLOUR_STRING[palette_colour])
	var log_context_data = {
		"palette_colours": palette_colours_strings, "palette_size": palette_size, "palette_colours_remaining": palette_size - current_palette_colour_index
	}
	var log_play_data = {"message": "Palette failed", "context": log_context_data}
	Logger.log_play_data(log_play_data)


func _on_failed_cooldown_timer_timeout() -> void:
	generate_new_palette()


func on_palette_cleared(enemy_to_ignore: Enemy = null) -> void:
	SfxManager.play_sound("PaletteClearedSFX", -17.0, -15.0, 1.0, 1.0)
	SignalBus.palette_cleared.emit()
	UpgradeManager.on_palette_cleared(self)

	palette_completed_overlay.modulate.a = 1.0
	var palette_colours_strings = []
	for palette_colour in palette_colours:
		palette_colours_strings.append(Globals.COLOUR_STRING[palette_colour])
	var log_context_data = {"palette_colours": palette_colours_strings, "palette_size": palette_size}
	var log_play_data = {"message": "Palette cleared", "context": log_context_data}
	Logger.log_play_data(log_play_data)

	generate_new_palette(enemy_to_ignore)


func sort_by_distance_to_player_ascending(a: Enemy, b: Enemy):
	if a.global_position.distance_to(Globals.player.global_position) < b.global_position.distance_to(Globals.player.global_position):
		return true
	return false


func generate_new_palette(enemy_to_ignore: Enemy = null) -> void:
	_set_palette_sprites()
	palette_colours.resize(palette_size)

	# Recalculation: Gets the closest enemies and uses their colours to generate the palette
	# If there are too little enemies to fill out the palette, the remaining colours will be filled only using colours previously picked
	# If there are no enemies, the palette will be filled with random colours
	var all_enemies_alive = Globals.get_all_enemies_alive()
	all_enemies_alive.erase(enemy_to_ignore)
	all_enemies_alive.sort_custom(sort_by_distance_to_player_ascending)

	var closest_enemies: Array[Enemy]
	closest_enemies = all_enemies_alive.slice(0, palette_size)

	var pickable_colours: Array[Globals.Colour]
	for enemy in closest_enemies:
		pickable_colours.append(enemy.colour)

	for remaining_colours in palette_size - pickable_colours.size():
		if closest_enemies.size() <= 0:
			pickable_colours.append(Globals.Colour.values().pick_random())
			continue
		pickable_colours.append(pickable_colours.pick_random())

	for palette_colour in palette_colours.size():
		var random_colour = pickable_colours.pop_front()
		palette_colours[palette_colour] = random_colour

		var palette_colour_sprite: PaletteColour = palette_colour_sprites.get_children()[palette_colour]
		palette_colour_sprite.update_shader_modulate(Globals.COLOUR_VISUAL_VALUE_NO_GLOW[random_colour])

	current_palette_colour_index = 0

	grace_period_timer.start(grace_period_time)

	UpgradeManager.on_palette_generated()


func _set_palette_sprites() -> void:
	for palette_colour_sprite in palette_colour_sprites.get_children():
		palette_colour_sprites.remove_child(palette_colour_sprite)
		palette_colour_sprite.queue_free()
	for i in palette_size:
		var palette_colour = PALETTE_COLOUR.instantiate()
		palette_colour_sprites.add_child(palette_colour)
		palette_colour.update_shader_alpha(0.4)
		if i == 0:
			palette_colour.update_shader_alpha(1.0)
