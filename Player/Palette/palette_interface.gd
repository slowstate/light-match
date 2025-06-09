extends HBoxContainer
#
#const PLAYER_UPGRADE_BUTTON = preload("res://Player/Upgrades/player_upgrade_button.tscn")
#
#var palette: Palette
#
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#palette = owner as Palette
#assert(palette != null, "Player is null.")
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#pass
#
#
#func update_palette_interface() -> void:
#get_children().clear()
#for colour in palette.palette_colours:
#var new_colour = Sprite2D.new()
#new_colour.texture = GradientTexture2D.new()
#var palette_texture: GradientTexture2D = new_colour.texture
#palette_texture.gradient.colors[0] = Globals.COLOUR_VISUAL_VALUE[colour]
#new_upgrade_button.custom_minimum_size = Vector2(24, 24)
#for upgrade in player.upgrades:
#var new_upgrade_button = PLAYER_UPGRADE_BUTTON.instantiate()
#new_upgrade_button.text = str(upgrade.type)
#new_upgrade_button.add_theme_font_size_override("font_size", 40)
#new_upgrade_button.custom_minimum_size = Vector2(80, 80)
#new_upgrade_button.disabled = true
#add_child(new_upgrade_button)
