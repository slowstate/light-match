extends Appendage


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer_value(Globals.CollisionLayer.ENEMIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BOUNDARIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BULLETS, true)
	self.area_entered.connect(_on_area_entered)


func _set_sprite_colour(new_colour: Globals.Colour) -> void:
	colour = new_colour
	set_colour(Globals.COLOUR_VISUAL_VALUE[colour])
