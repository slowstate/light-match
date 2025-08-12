extends EnemySprite

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var oracle_eye_light: Sprite2D = $OracleEyeLight
@onready var oracle_body_light_1: Sprite2D = $OracleBodyLight1
@onready var oracle_body_light_2: Sprite2D = $OracleBodyLight2
@onready var oracle_blink_timer: Timer = $OracleBlinkTimer


func _on_oracle_blink_timer_timeout() -> void:
	animation_player.play("Oracle_Blink")
	oracle_blink_timer.start(randf_range(0.2, 5.0))


func set_colour(colour: Globals.Colour) -> void:
	oracle_eye_light.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	oracle_body_light_1.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	oracle_body_light_2.modulate = Globals.COLOUR_VISUAL_VALUE[colour]


func set_health(health: int) -> void:
	oracle_eye_light.visible = false if health < 1 else true
	oracle_body_light_1.visible = false if health < 2 else true
	oracle_body_light_2.visible = false if health < 3 else true


func dim_lights(dim_amount: float) -> void:
	oracle_eye_light.self_modulate.a = 1.0 - dim_amount
	oracle_body_light_1.self_modulate.a = 1.0 - dim_amount
	oracle_body_light_2.self_modulate.a = 1.0 - dim_amount


func get_dim_lights_amount() -> float:
	return 1.0 - oracle_body_light_2.self_modulate.a
