class_name RoundActiveState
extends State

var main_menu = load("res://Menus/MainMenu/main_menu.tscn")
var current_round: Round
var arena
var enemies_left_to_spawn_this_round: int = 0
var concurrent_enemies_spawn_limit: int = 1

@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer


func enter() -> void:
	arena = owner as Arena
	assert(arena != null, "Arena is null.")
	if not SignalBus.is_connected("enemy_died", on_enemy_died):
		SignalBus.connect("enemy_died", on_enemy_died)
	if not SignalBus.is_connected("palette_cleared", _on_palette_cleared):
		SignalBus.connect("palette_cleared", _on_palette_cleared)
	if Globals.player != null:
		Globals.player.controls_enabled = true
	if not SignalBus.player_died.is_connected(_on_player_died):
		SignalBus.player_died.connect(_on_player_died)
	_load_round(arena.current_round_number)


func exit() -> void:
	pass


func update(_delta: float) -> void:
	if no_enemies_remaining_this_round():
		transition.emit("UpgradeSelection")


func physics_update(_delta: float) -> void:
	pass


func _load_round(round_number: int) -> void:
	var round_resource_path = "res://Arena/Rounds/%s.tres"
	var round_number_string := str(round_number) if round_number <= 16 else "endless"
	current_round = load(round_resource_path % round_number_string) as Round
	arena.total_enemies_to_spawn_this_round = current_round.total_enemies_to_spawn if round_number <= 16 else 5 + round_number * 3
	concurrent_enemies_spawn_limit = floori(5.0 + float(round_number) / 2.0)
	if round_number_string == "endless":
		concurrent_enemies_spawn_limit += floori(pow(float(round_number) - 16.0, 1.7))
		arena.total_enemies_to_spawn_this_round += floori(pow(float(round_number) - 16.0, 2.0))
	enemies_left_to_spawn_this_round = arena.total_enemies_to_spawn_this_round
	arena.enemy_types_to_spawn = current_round.enemy_types_to_spawn()

	var enemy_spawn_timer_wait_time := 1.3 / round_number
	enemy_spawn_timer.wait_time = enemy_spawn_timer_wait_time
	enemy_spawn_timer.start()

	arena.palette_milestone_1_this_round = floori(float(arena.total_enemies_to_spawn_this_round) / float(Globals.player.palette.palette_size) * 0.3)
	arena.palette_milestone_2_this_round = floori(float(arena.total_enemies_to_spawn_this_round) / float(Globals.player.palette.palette_size) * 0.8)
	arena.palettes_cleared_this_round = 0


func _on_enemy_spawn_timer_timeout() -> void:
	if enemies_left_to_spawn_this_round <= 0:
		return
	var new_enemy
	match arena.enemy_types_to_spawn.pick_random():
		Globals.EnemyType.BOT:
			new_enemy = Bot.create(_random_location_in_arena(), current_round.bots_health)
		Globals.EnemyType.LIZARD:
			new_enemy = Lizard.create(_random_location_in_arena(), current_round.lizards_health)
		Globals.EnemyType.TANK:
			new_enemy = Tank.create(_random_location_in_arena(), current_round.tanks_health)
		Globals.EnemyType.ORACLE:
			new_enemy = Oracle.create(_random_location_in_arena(), current_round.oracles_health)
		Globals.EnemyType.STAR:
			new_enemy = Star.create(_random_location_in_arena(), current_round.stars_health)
	add_child(new_enemy)

	enemies_left_to_spawn_this_round -= 1
	enemy_spawn_timer.start()


func _random_location_in_arena() -> Vector2:
	var random_location = Vector2(randi_range(0, 3840), randi_range(0, 2160))
	while (random_location - Globals.player.global_position).length() < 960:
		random_location = Vector2(randi_range(0, 3840), randi_range(0, 2160))
	return random_location


func on_enemy_died(_enemy: Enemy) -> void:
	pass


func _on_palette_cleared() -> void:
	arena.palettes_cleared_this_round += 1


func no_enemies_remaining_this_round() -> bool:
	if (
		enemies_left_to_spawn_this_round > 0
		or get_tree().get_nodes_in_group("Bots").size() > 0
		or get_tree().get_nodes_in_group("Lizards").size() > 0
		or get_tree().get_nodes_in_group("Tanks").size() > 0
		or get_tree().get_nodes_in_group("Oracles").size() > 0
		or get_tree().get_nodes_in_group("Stars").size() > 0
	):
		return false
	return true


func _on_player_died() -> void:
	arena.time_limit_timer.paused = true
	transition.emit("ScoreScreen")
