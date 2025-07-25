extends Condition

var spawn_increase: float = 0.1


func _init() -> void:
	name = "Swarm"
	description = "Spawn " + str(spawn_increase * 100) + "% more enemies"
	points_per_round = 3


func on_round_loaded(round: Round) -> void:
	var increased_total_enemies_to_spawn = roundi(float(round.total_enemies_to_spawn) * (1 + spawn_increase))
	round.total_enemies_to_spawn = increased_total_enemies_to_spawn
