class_name Palette
extends Node2D

var palette_colours: Array[Globals.Colour]
var current_palette_colour_index: int
var palette_size: int = 3

var palette_colour_sprites: Array[Sprite2D]
@onready var palette_colour_0: Sprite2D = $PaletteColour0
@onready var palette_colour_1: Sprite2D = $PaletteColour1
@onready var palette_colour_2: Sprite2D = $PaletteColour2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("enemy_died", on_enemy_died)
	palette_colour_sprites = [palette_colour_0, palette_colour_1, palette_colour_2]
	_generate_new_palette()


func on_enemy_died(enemy: Enemy) -> void:
	if !enemy:
		return

	if enemy.colour != palette_colours[current_palette_colour_index]:
		UpgradeManager.on_palette_failed()
		_generate_new_palette()
		return

	if current_palette_colour_index < palette_size - 1:
		palette_colour_sprites[current_palette_colour_index].visible = false
		current_palette_colour_index += 1
	else:
		on_palette_cleared()


func on_palette_cleared() -> void:
	SignalBus.palette_cleared.emit()
	UpgradeManager.on_palette_cleared()
	_generate_new_palette()


func _generate_new_palette() -> void:
	current_palette_colour_index = 0
	palette_colours.resize(palette_size)
	for palette_colour in palette_colours.size():
		var random_colour = Globals.pick_random_colour()
		palette_colours[palette_colour] = random_colour

		var palette_texture: GradientTexture2D = palette_colour_sprites[palette_colour].texture
		palette_texture.gradient.colors[0] = Globals.COLOUR_VISUAL_VALUE[random_colour]
		palette_colour_sprites[palette_colour].visible = true
	UpgradeManager.on_palette_generated()
