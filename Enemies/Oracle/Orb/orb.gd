extends Area2D

var oracle: Oracle

@onready var oracle_orb_light: Sprite2D = $OracleOrbLight


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	oracle = owner as Oracle
	assert(oracle != null, "The state type must be used only in the Oracle scene. It needs the owner to be a Oracle node.")

	set_collision_layer_value(Globals.CollisionLayer.ENEMIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BOUNDARIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BULLETS, true)
	self.area_entered.connect(_on_area_entered)
	oracle_orb_light.modulate = Globals.COLOUR_VISUAL_VALUE[oracle.orb_colour]


func _on_area_entered(area: Area2D) -> void:
	var bullet = area as Bullet
	if bullet.colour != oracle.orb_colour:
		return
	queue_free()
