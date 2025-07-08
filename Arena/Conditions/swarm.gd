extends Condition

var spawn_increase: float


func _init() -> void:
	name = "Swarm"
	spawn_increase = snappedf(randf_range(0.1, 0.2), 0.01)
	description = "Spawn " + str(spawn_increase * 100) + "% more enemies"
	points_per_round = 1 if spawn_increase < 0.15 else 2


func on_round_loaded(round: Round) -> void:
	var increased_total_enemies_to_spawn = roundi(float(round.total_enemies_to_spawn) * (1 + spawn_increase))
	round.total_enemies_to_spawn = increased_total_enemies_to_spawn
