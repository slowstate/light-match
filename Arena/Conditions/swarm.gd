extends Condition

var spawn_limit_increase: float = 0.5


func _init() -> void:
	name = "Swarm"
	description = "Increases the maximum number of enemies alive by " + str(spawn_limit_increase * 100) + "%"
	points_per_round = 3


func on_round_loaded(round: Round) -> void:
	var increased_total_enemies_to_spawn = roundi(float(round.total_enemies_to_spawn) * (1 + spawn_limit_increase))
	round.concurrent_enemies_spawn_limit = increased_total_enemies_to_spawn
