class_name RoundActiveState
extends State

var main_menu = load("res://Menus/MainMenu/main_menu.tscn")
var current_round: Round
var arena
var enemies_to_spawn: Array[Globals.EnemyType]

@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer


func enter() -> void:
	arena = owner as Arena
	assert(arena != null, "The state type must be used only in the Bot scene. It needs the owner to be a Bot node.")
	if not SignalBus.is_connected("enemy_died", on_enemy_died):
		SignalBus.connect("enemy_died", on_enemy_died)
	if not SignalBus.is_connected("palette_cleared", on_palette_cleared):
		SignalBus.connect("palette_cleared", on_palette_cleared)
	_load_round(arena.current_round_number)
	if Globals.player != null:
		Globals.player.controls_enabled = true
	if not SignalBus.player_died.is_connected(_on_player_died):
		SignalBus.player_died.connect(_on_player_died)


func exit() -> void:
	pass


func update(_delta: float) -> void:
	if no_enemies_remaining_this_round():
		transition.emit("UpgradeSelection")


func physics_update(_delta: float) -> void:
	pass


func _load_round(round_number: int) -> void:
	var round_resource_path = "res://Arena/Rounds/%s.tres"
	var round_number_string = str(round_number) if round_number <= 16 else "endless"
	current_round = load(round_resource_path % round_number_string) as Round
	arena.total_enemies_to_spawn_this_round = current_round.total_enemies_to_spawn
	if round_number_string == "endless":
		arena.total_enemies_to_spawn_this_round += pow(round_number - 16, 2)
	enemies_to_spawn = current_round.enemies_to_spawn()
	arena.palettes_cleared_this_round = 0
	enemy_spawn_timer.start(1.0)


func _on_enemy_spawn_timer_timeout() -> void:
	if arena.total_enemies_to_spawn_this_round <= 0:
		return
	var new_enemy
	match enemies_to_spawn.pick_random():
		Globals.EnemyType.BOT:
			new_enemy = Bot.create(_random_location_in_arena(), current_round.bots_health)  #, Globals.Colour.BLUE)
		Globals.EnemyType.LIZARD:
			new_enemy = Lizard.create(_random_location_in_arena(), current_round.lizards_health)
		Globals.EnemyType.TANK:
			new_enemy = Tank.create(_random_location_in_arena(), current_round.tanks_health)
		Globals.EnemyType.ORACLE:
			new_enemy = Oracle.create(_random_location_in_arena(), current_round.oracles_health)
		Globals.EnemyType.STAR:
			new_enemy = Star.create(_random_location_in_arena(), current_round.stars_health)
	add_child(new_enemy)

	arena.total_enemies_to_spawn_this_round -= 1
	enemy_spawn_timer.start(1.0)


func _random_location_in_arena() -> Vector2:
	var random_location = Vector2(randi_range(0, 3840), randi_range(0, 2160))
	while (random_location - Globals.player.global_position).length() < 500:
		random_location = Vector2(randi_range(0, 3840), randi_range(0, 2160))
	return random_location


func on_enemy_died(_enemy: Enemy) -> void:
	pass


func on_palette_cleared() -> void:
	arena.palettes_cleared_this_round += 1


func no_enemies_remaining_this_round() -> bool:
	if (
		arena.total_enemies_to_spawn_this_round > 0
		or get_tree().get_nodes_in_group("Bots").size() > 0
		or get_tree().get_nodes_in_group("Lizards").size() > 0
		or get_tree().get_nodes_in_group("Tanks").size() > 0
		or get_tree().get_nodes_in_group("Oracles").size() > 0
		or get_tree().get_nodes_in_group("Stars").size() > 0
	):
		return false
	return true


func _on_player_died() -> void:
	#get_tree().get_nodes_in_group("Bots").clear()
	get_tree().call_deferred("change_scene_to_packed", main_menu)
