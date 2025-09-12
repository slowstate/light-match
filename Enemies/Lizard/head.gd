extends Appendage

const LIZARD_HEAD_DEATH_PARTICLES = preload("res://Enemies/Lizard/VFX/lizard_head_death_particles.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var liz_head: Sprite2D = $HeadSprite2D/LizHead


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.area_entered.connect(_on_area_entered)


func play_attack_animation() -> void:
	animation_player.stop()
	animation_player.play("Liz_Attack")


func spawn_death_particles(_amplitude: float = 1.0) -> void:
	var death_particles = LIZARD_HEAD_DEATH_PARTICLES.instantiate()
	death_particles.global_position = liz_head.global_position
	death_particles.set_angle(-get_parent().rotation_degrees + 90)
	get_tree().root.add_child(death_particles)
