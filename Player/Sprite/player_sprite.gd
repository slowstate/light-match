class_name PlayerSprite
extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var torso_light: Sprite2D = $Torso/TorsoLight
@onready var left_forearm_light: Sprite2D = $Torso/LeftForearm/LeftArm/LeftForearmLight
@onready var left_arm_light: Sprite2D = $Torso/LeftForearm/LeftArm/LeftArmLight
@onready var gun_circle_light: Sprite2D = $Torso/Gun/GunCircleLight
@onready var gun_light_1: Sprite2D = $Torso/Gun/GunLight1
@onready var gun_light_2: Sprite2D = $Torso/Gun/GunLight2
@onready var gun_light_3: Sprite2D = $Torso/Gun/GunLight3
@onready var right_forearm_light: Sprite2D = $Torso/RightForearmLight
@onready var left_shoulder_light: Sprite2D = $Torso/LeftShoulder/LeftShoulderLight
@onready var right_shoulder_light: Sprite2D = $Torso/RightShoulder/RightShoulderLight
@onready var head_light: Sprite2D = $Head/HeadLight


func set_light_visibility(light_visibility: bool) -> void:
	torso_light.visible = light_visibility
	left_forearm_light.visible = light_visibility
	left_arm_light.visible = light_visibility
	gun_circle_light.visible = light_visibility
	gun_light_1.visible = light_visibility
	gun_light_2.visible = light_visibility
	gun_light_3.visible = light_visibility
	right_forearm_light.visible = light_visibility
	left_shoulder_light.visible = light_visibility
	right_shoulder_light.visible = light_visibility
	head_light.visible = light_visibility


func set_colour(colour: Globals.Colour) -> void:
	torso_light.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	left_forearm_light.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	left_arm_light.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	gun_circle_light.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	gun_light_1.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	gun_light_2.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	gun_light_3.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	right_forearm_light.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	left_shoulder_light.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	right_shoulder_light.modulate = Globals.COLOUR_VISUAL_VALUE[colour]
	head_light.modulate = Globals.COLOUR_VISUAL_VALUE[colour]


func play_move_animation(play: bool) -> void:
	if play:
		if animation_player.is_playing():
			return
		animation_player.play("Player_Move")
	if !play and animation_player.current_animation == "Player_Move":
		animation_player.stop()


func play_shoot_animation() -> void:
	animation_player.stop()
	animation_player.play("Player_Shoot")
