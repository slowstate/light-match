extends Appendage

@export var shell_number: int

var star: Star

@onready var star_shell_light: Sprite2D = $StarShellLight


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	star = owner as Star
	assert(star != null, "The state type must be used only in the Star scene. It needs the owner to be a Star node.")

	set_collision_layer_value(Globals.CollisionLayer.ENEMIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BOUNDARIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BULLETS, true)
	self.area_entered.connect(_on_area_entered)
	set_colour(star.shell_colours[shell_number])


func _on_area_entered(area: Area2D) -> void:
	var bullet = area as Bullet
	if bullet.colour != star.shell_colours[shell_number]:
		SfxManager.play_sound("EnemyDeflectSFX", -5.0, -3.0, 0.95, 1.05)
		return
	SfxManager.play_sound("EnemyHitSFX", -25.0,-23.0,2.0,2.2)
	queue_free()
