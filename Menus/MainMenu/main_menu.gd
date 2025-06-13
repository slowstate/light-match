extends Node2D

const ARENA = preload("res://Arena/arena.tscn")
const BULLET = preload("res://Player/Bullet/bullet.tscn")

@onready var title_animation_player: AnimationPlayer = $TitleAnimationPlayer
@onready var bullet_spawn_timer: Timer = $BulletSpawnTimer
@onready var tutorial: Node2D = $Tutorial


func _ready() -> void:
	title_animation_player.play("Title_Screen")
	tutorial.visible = false


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(ARENA)


func _on_how_to_play_button_pressed() -> void:
	tutorial.visible = true


func _on_return_to_main_menu_button_pressed() -> void:
	tutorial.visible = false


func _on_exit_button_pressed() -> void:
	get_tree().quit()


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
