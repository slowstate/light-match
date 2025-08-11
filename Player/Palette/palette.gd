class_name Palette
extends Node2D

const PALETTE_COLOUR = preload("res://Player/Palette/palette_colour.tscn")

var palette_colours: Array[Globals.Colour]
var current_palette_colour_index: int = 0
var palette_size: int = 3
var palette_can_fail: bool = true
var timer_progress: float = 0.0
var reload_time: float = 1.0
var reload_animation_progress: float = 0.0
var grace_period_time: float = 0.5

@onready var palette_colour_sprites: HBoxContainer = $PaletteColourSprites
@onready var reload_timer: Timer = $ReloadTimer
@onready var grace_period_timer: Timer = $GracePeriodTimer
@onready var failed_cooldown_timer: Timer = $FailedCooldownTimer


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

	timer_progress = 0.0
	if !failed_cooldown_timer.is_stopped():
		timer_progress = 1.0 - failed_cooldown_timer.time_left / failed_cooldown_timer.wait_time
		for palette_colour_sprite in palette_colour_sprites.get_children():
			palette_colour_sprite.update_shader_timer_progress(clamp(timer_progress * 2, 0.0, 1.0))


func _on_enemy_died(enemy: Enemy) -> void:
	if enemy == null:
		return

	if !failed_cooldown_timer.is_stopped() or !reload_timer.is_stopped():
		return

	if enemy.colour != palette_colours[current_palette_colour_index]:
		if grace_period_timer.is_stopped() and palette_can_fail:
			on_palette_failed()
		return

	if current_palette_colour_index >= palette_colours.size() - 1:
		on_palette_cleared()
		return

	palette_colour_sprites.get_children()[current_palette_colour_index].visible = false

	current_palette_colour_index += 1
	palette_colour_sprites.get_children()[current_palette_colour_index].update_shader_alpha(1.0)
	SfxManager.play_sound("PaletteSuccessSFX", -15.0, -13.0, 0.95, 1.05)


func reload_palette() -> void:
	if !failed_cooldown_timer.is_stopped() or !reload_timer.is_stopped():
		return

	for palette_colour in palette_colour_sprites.get_children():
		palette_colour.update_shader_modulate(Color(1.0, 1.0, 1.0, 1.0))
		palette_colour.update_shader_alpha(0.4)
	reload_timer.start(reload_time)


func _on_reload_timer_timeout() -> void:
	generate_new_palette()


func on_palette_failed() -> void:
	for palette_colour in palette_colour_sprites.get_children():
		palette_colour.update_shader_modulate(Color(1.0, 1.0, 1.0, 1.0))
		palette_colour.update_shader_alpha(0.4)
	failed_cooldown_timer.start(1)
	SfxManager.play_sound("PaletteFailSFX", -15.0, -13.0, 0.95, 1.05)
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
	UpgradeManager.on_palette_failed()
	generate_new_palette()


func on_palette_cleared() -> void:
	SfxManager.play_sound("PaletteClearedSFX", -17.0, -15.0, 0.95, 1.05)
	SignalBus.palette_cleared.emit()
	UpgradeManager.on_palette_cleared(self)

	var palette_colours_strings = []
	for palette_colour in palette_colours:
		palette_colours_strings.append(Globals.COLOUR_STRING[palette_colour])
	var log_context_data = {"palette_colours": palette_colours_strings, "palette_size": palette_size}
	var log_play_data = {"message": "Palette cleared", "context": log_context_data}
	Logger.log_play_data(log_play_data)

	generate_new_palette()


func generate_new_palette() -> void:
	_set_palette_sprites()
	palette_colours.resize(palette_size)
	for palette_colour in palette_colours.size():
		var random_colour = Globals.Colour.values().pick_random()
		palette_colours[palette_colour] = random_colour
		var palette_colour_sprite: PaletteColour = palette_colour_sprites.get_children()[palette_colour]
		palette_colour_sprite.update_shader_modulate(Globals.COLOUR_VISUAL_VALUE[random_colour])
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
