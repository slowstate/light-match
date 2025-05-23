extends Area2D

var oracle: Oracle

@onready var orb_sprite_2d: Sprite2D = $OrbSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	oracle = owner as Oracle
	assert(oracle != null, "The state type must be used only in the Oracle scene. It needs the owner to be a Oracle node.")

	set_collision_layer_value(Globals.CollisionLayer.ENEMIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BOUNDARIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BULLETS, true)
	self.area_entered.connect(_on_area_entered)
	_set_sprite_colour()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _set_sprite_colour() -> void:
	match oracle.orb_colour:
		Globals.Colour.BLUE:
			orb_sprite_2d.texture = load("res://Enemies/Colours/Blue/enemy_blue.png")
		Globals.Colour.GREEN:
			orb_sprite_2d.texture = load("res://Enemies/Colours/Green/enemy_green.png")
		Globals.Colour.RED:
			orb_sprite_2d.texture = load("res://Enemies/Colours/Red/enemy_red.png")


func _on_area_entered(area: Area2D) -> void:
	var bullet = area as Bullet
	if bullet.colour != oracle.orb_colour:
		return
	queue_free()
