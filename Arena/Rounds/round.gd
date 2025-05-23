class_name Round
extends Resource

@export var total_enemies_to_spawn: int

@export var spawn_bots: bool
@export var spawn_lizards: bool
@export var spawn_tanks: bool
@export var spawn_oracles: bool
@export var spawn_stars: bool


func enemies_to_spawn() -> Array[Globals.EnemyTypes]:
	var enemies_to_spawn: Array[Globals.EnemyTypes]
	if spawn_bots:
		enemies_to_spawn.append(Globals.EnemyTypes.BOT)
	if spawn_lizards:
		enemies_to_spawn.append(Globals.EnemyTypes.LIZARD)
	if spawn_tanks:
		enemies_to_spawn.append(Globals.EnemyTypes.TANK)
	if spawn_oracles:
		enemies_to_spawn.append(Globals.EnemyTypes.ORACLE)
	if spawn_stars:
		enemies_to_spawn.append(Globals.EnemyTypes.STAR)
	return enemies_to_spawn
