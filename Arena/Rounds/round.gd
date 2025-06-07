class_name Round
extends Resource

@export var total_enemies_to_spawn: int

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


func enemies_to_spawn() -> Array[Globals.EnemyType]:
	var enemies_to_spawn: Array[Globals.EnemyType]
	if spawn_bots:
		enemies_to_spawn.append(Globals.EnemyType.BOT)
	if spawn_lizards:
		enemies_to_spawn.append(Globals.EnemyType.LIZARD)
	if spawn_tanks:
		enemies_to_spawn.append(Globals.EnemyType.TANK)
	if spawn_oracles:
		enemies_to_spawn.append(Globals.EnemyType.ORACLE)
	if spawn_stars:
		enemies_to_spawn.append(Globals.EnemyType.STAR)
	return enemies_to_spawn
