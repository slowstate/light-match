class_name Palette
extends Node2D

var palette_colours: Array[Globals.Colour]
var current_palette_colour_index: int = 0
var palette_size: int = 3
var palette_can_fail: bool = true
var timer_progress: float = 0.0

var palette_colour_sprites: Array[PaletteColour]
@onready var palette_colour_0: PaletteColour = $PaletteColour0
@onready var palette_colour_1: PaletteColour = $PaletteColour1
@onready var palette_colour_2: PaletteColour = $PaletteColour2
@onready var palette_colour_3: PaletteColour = $PaletteColour3
@onready var palette_colour_4: PaletteColour = $PaletteColour4
@onready var palette_colour_5: PaletteColour = $PaletteColour5
@onready var palette_colour_6: PaletteColour = $PaletteColour6
@onready var failed_cooldown_timer: Timer = $FailedCooldownTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("enemy_died", _on_enemy_died)


func _process(delta: float) -> void:
	timer_progress = 0.0
	if !failed_cooldown_timer.is_stopped():
		timer_progress = 1.0 - failed_cooldown_timer.time_left / failed_cooldown_timer.wait_time
	for palette_colour_sprite in palette_colour_sprites:
		palette_colour_sprite.update_shader_timer_progress(timer_progress)


func _on_enemy_died(enemy: Enemy) -> void:
	if enemy == null:
		return

	if !failed_cooldown_timer.is_stopped():
		return

	if enemy.colour != palette_colours[current_palette_colour_index]:
		if palette_can_fail:
			on_palette_failed()
		return

	if current_palette_colour_index >= palette_colours.size() - 1:
		on_palette_cleared()
		return

	palette_colour_sprites[current_palette_colour_index].visible = false

	current_palette_colour_index += 1


func on_palette_failed() -> void:
	failed_cooldown_timer.start(0.5)
	for palette_colour_sprite in palette_colour_sprites:
		palette_colour_sprite.update_shader_rand(randf_range(-1.0, 1.0))


func _on_failed_cooldown_timer_timeout() -> void:
	UpgradeManager.on_palette_failed()
	generate_new_palette()


func on_palette_cleared() -> void:
	SignalBus.palette_cleared.emit()
	UpgradeManager.on_palette_cleared(self)
	generate_new_palette()


func generate_new_palette() -> void:
	_set_palette_sprites()
	palette_colours.resize(palette_size)
	for palette_colour in palette_colours.size():
		var random_colour = Globals.Colour.values().pick_random()
		palette_colours[palette_colour] = random_colour
		var palette_colour_sprite: PaletteColour = palette_colour_sprites[palette_colour]
		palette_colour_sprite.update_shader_modulate(Globals.COLOUR_VISUAL_VALUE[random_colour])
	current_palette_colour_index = 0

	UpgradeManager.on_palette_generated()


func _set_palette_sprites() -> void:
	palette_colour_0.visible = false
	palette_colour_1.visible = false
	palette_colour_2.visible = false
	palette_colour_3.visible = false
	palette_colour_4.visible = false
	palette_colour_5.visible = false
	palette_colour_6.visible = false
	palette_colour_sprites.resize(palette_size)
	if palette_size > 0:
		palette_colour_sprites[0] = palette_colour_0
	if palette_size > 1:
		palette_colour_sprites[1] = palette_colour_1
	if palette_size > 2:
		palette_colour_sprites[2] = palette_colour_2
	if palette_size > 3:
		palette_colour_sprites[3] = palette_colour_3
	if palette_size > 4:
		palette_colour_sprites[4] = palette_colour_4
	if palette_size > 5:
		palette_colour_sprites[5] = palette_colour_5
	if palette_size > 6:
		palette_colour_sprites[6] = palette_colour_6
	for palette_colour_sprite in palette_colour_sprites:
		palette_colour_sprite.visible = true
	position.x = -(palette_colour_sprites.front().position.x + palette_colour_sprites.back().position.x) / 2
