extends Node2D

const CROSSHAIR = preload("res://HUD/Crosshair.png")
const BULLET = preload("res://Player/Bullet/bullet.tscn")
const ARENA = preload("res://Arena/arena.tscn")
const TUTORIAL = preload("res://Tutorial/tutorial.tscn")

@onready var title_animation_player: AnimationPlayer = $TitleAnimationPlayer
@onready var bullet_spawn_timer: Timer = $BulletSpawnTimer
@onready var music_manager: Node2D = $MusicManager
@onready var tutorial: Control = $Tutorial
@onready var settings: Control = $Settings


func _ready() -> void:
	get_tree().paused = false
	var log_data = {"message": "Scene ready"}
	Logger.log_info(log_data)
	Input.set_custom_mouse_cursor(CROSSHAIR, Input.CURSOR_ARROW, Vector2(26, 17))
	title_animation_player.play("Title_Screen")
	tutorial.visible = false
	settings.visible = false
	music_manager.update_music(0.0)


#region Start
func _on_start_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)


func _on_start_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	if Save.lifetime_palettes > 0:
		get_tree().change_scene_to_packed(ARENA)
	else:
		get_tree().change_scene_to_packed(TUTORIAL)


#endregion


#region Settings
func _on_settings_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)


func _on_settings_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	settings.visible = true


#endregion


#region Exit
func _on_exit_button_mouse_entered() -> void:
	SfxManager.play_sound("ButtonHoverSFX", -7.0, -5.0, 0.95, 1.05)


func _on_exit_button_pressed() -> void:
	SfxManager.play_sound("ButtonClickSFX", -20.0, -18.0, 0.95, 1.05)
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)


#endregion


func _randomly_spawn_bullet() -> void:
	var random_spawn_position: Vector2
	match randi_range(0, 3):
		0:
			random_spawn_position = Vector2(randi_range(1920, 1930), randi_range(0, 1080))
		1:
			random_spawn_position = Vector2(randi_range(0, 1920), randi_range(10, 0))
		2:
			random_spawn_position = Vector2(randi_range(-10, 0), randi_range(0, 1080))
		3:
			random_spawn_position = Vector2(randi_range(0, 1920), randi_range(1080, 1090))
	var random_target_position: Vector2 = Vector2(randi_range(671, 1301), randi_range(513, 566))
	var new_bullet = Bullet.create(random_spawn_position, (random_target_position - random_spawn_position).angle(), Globals.Colour.values().pick_random())
	add_child(new_bullet)


func _on_bullet_spawn_timer_timeout() -> void:
	_randomly_spawn_bullet()
	bullet_spawn_timer.start(randf_range(0.2, 3.0))
