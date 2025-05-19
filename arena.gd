extends Node2D

@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_spawn_timer.start(1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_spawn_timer_timeout() -> void:
	print("Enemy spawned")
	var new_bot = Bot.create(Globals.BulletColour.Red, Vector2(randi_range(0, 3840), randi_range(0, 2160)))
	get_tree().root.add_child(new_bot)
	enemy_spawn_timer.start(1.0)
