extends EnemySprite

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bot_light_1: Sprite2D = $BotLight1
@onready var bot_light_2: Sprite2D = $BotLight2
@onready var bot_light_3: Sprite2D = $BotLight3


func play_move_animation(play: bool) -> void:
	if play:
		if animation_player.is_playing():
			return
		animation_player.play("Bot_Move")
	if !play and animation_player.current_animation == "Bot_Move":
		animation_player.stop()


func play_attack_animation() -> void:
	animation_player.stop()
	animation_player.play("Bot_Attack")


func set_colour(colour: Globals.Colour) -> void:
	bot_light_1.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	bot_light_2.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	bot_light_3.modulate = Globals.COLOUR_VISUAL_VALUE[colour]


func set_health(health: int) -> void:
	if health < 1:
		bot_light_1.visible = false
	if health < 2:
		bot_light_2.visible = false
	if health < 3:
		bot_light_3.visible = false
