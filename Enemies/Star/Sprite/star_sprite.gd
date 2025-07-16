extends EnemySprite

@onready var star_light_6: Sprite2D = $StarLight6


func set_colour(colour: Globals.Colour) -> void:
	star_light_6.modulate = Globals.COLOUR_VISUAL_VALUE[colour]


func set_health(health: int) -> void:
	star_light_6.visible = false if health < 1 else true
