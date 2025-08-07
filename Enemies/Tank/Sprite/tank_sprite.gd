extends EnemySprite

@onready var tank_light_1: Sprite2D = $TankLight1
@onready var tank_light_2: Sprite2D = $TankLight2
@onready var tank_light_3: Sprite2D = $TankLight3
@onready var tank_light_4: Sprite2D = $TankLight4
@onready var tank_light_5: Sprite2D = $TankLight5


func set_colour(colour: Globals.Colour) -> void:
	tank_light_1.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	tank_light_2.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	tank_light_3.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	tank_light_4.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	tank_light_5.modulate = Globals.COLOUR_VISUAL_VALUE[colour]


func set_health(health: int) -> void:
	tank_light_1.visible = false if health < 1 else true
	tank_light_2.visible = false if health < 2 else true
	tank_light_3.visible = false if health < 3 else true
	tank_light_4.visible = false if health < 4 else true
	tank_light_5.visible = false if health < 5 else true


func dim_lights(enabled: bool) -> void:
	tank_light_1.self_modulate.a = 0.5 if enabled else 1.0
	tank_light_2.self_modulate.a = 0.5 if enabled else 1.0
	tank_light_3.self_modulate.a = 0.5 if enabled else 1.0
	tank_light_4.self_modulate.a = 0.5 if enabled else 1.0
	tank_light_5.self_modulate.a = 0.5 if enabled else 1.0
