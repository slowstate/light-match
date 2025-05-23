extends Node2D

@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer

var total_enemies_to_spawn: int
var enemies_to_spawn: Array[Globals.EnemyTypes]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#enemy_spawn_timer.start(1.0)
	_load_round(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _load_round(round_number: int) -> void:
	var round_resource_path = "res://Arena/Rounds/%s.tres"
	var round_to_load: Round = load(round_resource_path % str(round_number))
	total_enemies_to_spawn = round_to_load.total_enemies_to_spawn
	enemies_to_spawn = round_to_load.enemies_to_spawn()
	enemy_spawn_timer.start(1.0)


func _on_enemy_spawn_timer_timeout() -> void:
	if total_enemies_to_spawn <= 0:
		return
	var new_enemy
	match enemies_to_spawn.pick_random():
		Globals.EnemyTypes.BOT:
			new_enemy = Bot.create(_random_location_in_arena())
		Globals.EnemyTypes.LIZARD:
			new_enemy = Lizard.create(_random_location_in_arena())
		Globals.EnemyTypes.TANK:
			new_enemy = Tank.create(_random_location_in_arena())
		Globals.EnemyTypes.ORACLE:
			new_enemy = Oracle.create(_random_location_in_arena())
		Globals.EnemyTypes.STAR:
			new_enemy = Star.create(_random_location_in_arena())
	get_tree().root.add_child(new_enemy)

	total_enemies_to_spawn -= 1
	enemy_spawn_timer.start(1.0)


func _random_location_in_arena() -> Vector2:
	return Vector2(randi_range(0, 3840), randi_range(0, 2160))
