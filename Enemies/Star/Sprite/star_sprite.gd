extends EnemySprite

@onready var star_light_6: Sprite2D = $StarLight6


func set_colour(colour: Globals.Colour) -> void:
	star_light_6.modulate = Globals.COLOUR_VISUAL_VALUE[colour]


func set_health(health: int) -> void:
	star_light_6.visible = false if health < 1 else true


func dim_lights(dim_amount: float) -> void:
	star_light_6.self_modulate.a = 1.0 - dim_amount


func get_dim_lights_amount() -> float:
	return 1.0 - star_light_6.self_modulate.a
