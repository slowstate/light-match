extends EnemySprite

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var liz_body_light_1: Sprite2D = $LizBodyLight1
@onready var liz_body_light_2: Sprite2D = $LizBodyLight2
@onready var liz_body_light_3: Sprite2D = $LizBodyLight3
@onready var liz_body_light_4: Sprite2D = $LizBodyLight4


func play_move_animation(play: bool) -> void:
	if play:
		if animation_player.is_playing():
			return
		animation_player.play("Liz_Walk")
	if !play and animation_player.current_animation == "Liz_Walk":
		animation_player.stop()


func set_colour(colour: Globals.Colour) -> void:
	liz_body_light_1.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	liz_body_light_2.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	liz_body_light_3.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	liz_body_light_4.modulate = Globals.COLOUR_VISUAL_VALUE[colour]


func set_health(health: int) -> void:
	liz_body_light_1.visible = false if health < 1 else true
	liz_body_light_2.visible = false if health < 2 else true
	liz_body_light_3.visible = false if health < 3 else true
	liz_body_light_4.visible = false if health < 4 else true
