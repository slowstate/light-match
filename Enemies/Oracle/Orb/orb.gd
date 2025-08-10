extends Appendage

const ORACLE_ORB_DEATH_PARTICLES = preload("res://Enemies/Oracle/VFX/oracle_orb_death_particles.tscn")

var oracle: Oracle
var original_position: Vector2 = position


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	oracle = owner as Oracle
	assert(oracle != null, "The state type must be used only in the Oracle scene. It needs the owner to be a Oracle node.")

	self.area_entered.connect(_on_area_entered)
	set_colour(oracle.orb_colour)


func spawn_death_particles(_amplitude: float = 1.0) -> void:
	var death_particles = ORACLE_ORB_DEATH_PARTICLES.instantiate()
	death_particles.global_position = global_position
	death_particles.set_colour(colour)
	get_tree().root.add_child(death_particles)
