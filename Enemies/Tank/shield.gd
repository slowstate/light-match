extends Area2D

var tank: Tank

@onready var shield_sprite_2d: Sprite2D = $ShieldSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	tank = owner as Tank
	assert(tank != null, "The state type must be used only in the Tank scene. It needs the owner to be a Tank node.")

	set_collision_layer_value(Globals.CollisionLayer.ENEMIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BOUNDARIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BULLETS, true)
	self.area_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	var _bullet = area as Bullet
	# TODO: Add FX for bullet blocked by Tank shield
	pass
