extends Condition

const HEAL_PARTICLES = preload("res://Enemies/VFX/heal_particles.tscn")

var heal_amount: int = 1


func _init() -> void:
	name = "Photon Absorption"
	description = "Enemies heal when hit by a different colour"
	added_dialogue = "Interesting, what if the targets had photon receptors..."
	points_per_round = 1


func on_enemy_hit(bullet: Bullet, enemy: Enemy) -> void:
	if bullet.colour != enemy.colour:
		enemy.set_health(enemy.health + 1)
		var heal_particles = HEAL_PARTICLES.instantiate()
		heal_particles.modulate = Globals.COLOUR_VISUAL_VALUE[enemy.colour]
		heal_particles.modulate.a = 1.0
		heal_particles.emitting = true
		enemy.add_child(heal_particles)
