extends Area2D

var colour: Globals.Colour = Globals.Colour.BLUE

@onready var liz_head_light: Sprite2D = $HeadSprite2D/LizHead/LizHeadLight


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer_value(Globals.CollisionLayer.ENEMIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BOUNDARIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BULLETS, true)
	self.area_entered.connect(_on_area_entered)


func _set_sprite_colour(new_colour: Globals.Colour) -> void:
	colour = new_colour
	liz_head_light.modulate = Globals.COLOUR_VISUAL_VALUE[colour]


func _on_area_entered(area: Area2D) -> void:
	var bullet = area as Bullet
	if bullet.colour != colour:
		return
	queue_free()
