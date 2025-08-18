extends Appendage

const STAR_SHELL_DEATH_PARTICLES = preload("res://Enemies/Star/VFX/star_shell_death_particles.tscn")

@export var shell_number: int

var star: Star

@onready var star_shell_light: Sprite2D = $StarShellLight


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	star = owner as Star
	assert(star != null, "The state type must be used only in the Star scene. It needs the owner to be a Star node.")

	self.area_entered.connect(_on_area_entered)
	set_colour(star.shell_colours[shell_number])


func spawn_death_particles(_amplitude: float = 1.0) -> void:
	var death_particles = STAR_SHELL_DEATH_PARTICLES.instantiate()
	death_particles.global_position = global_position
	get_tree().root.add_child(death_particles)
