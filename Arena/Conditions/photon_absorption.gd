extends Condition

const HEAL_PARTICLES = preload("res://Enemies/VFX/heal_particles.tscn")

var heal_amount: int = 1


func _init() -> void:
	name = tr("CONDITION_PHOTON_ABSORPTION_NAME")
	description = tr("CONDITION_PHOTON_ABSORPTION_DESCRIPTION")
	added_dialogue = tr("CONDITION_PHOTON_ABSORPTION_DIALOGUE")
	points_per_round = 1


func on_enemy_hit(bullet: Bullet, enemy: Enemy) -> void:
	if bullet.colour != enemy.colour:
		enemy.set_health(enemy.health + 1)
		var heal_particles = HEAL_PARTICLES.instantiate()
		heal_particles.modulate = Globals.COLOUR_VISUAL_VALUE[enemy.colour]
		heal_particles.modulate.a = 1.0
		heal_particles.emitting = true
		enemy.add_child(heal_particles)
		SfxManager.play_sound("EnemyHealSFX", -40.0, -38.0, 0.7, 0.8)
