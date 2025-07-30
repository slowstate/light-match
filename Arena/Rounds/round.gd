class_name Round
extends Resource

@export var total_enemies_to_spawn: int
@export var concurrent_enemies_spawn_limit: int

@export var spawn_bots: bool
@export var spawn_lizards: bool
@export var spawn_tanks: bool
@export var spawn_oracles: bool
@export var spawn_stars: bool

@export var bots_health: int = 1
@export var lizards_health: int = 1
@export var tanks_health: int = 1
@export var oracles_health: int = 1
@export var stars_health: int = 1


func enemy_types_to_spawn() -> Array[Globals.EnemyType]:
	var enemy_types: Array[Globals.EnemyType]
	if spawn_bots:
		enemy_types.append(Globals.EnemyType.BOT)
	if spawn_lizards:
		enemy_types.append(Globals.EnemyType.LIZARD)
	if spawn_tanks:
		enemy_types.append(Globals.EnemyType.TANK)
	if spawn_oracles:
		enemy_types.append(Globals.EnemyType.ORACLE)
	if spawn_stars:
		enemy_types.append(Globals.EnemyType.STAR)
	return enemy_types
