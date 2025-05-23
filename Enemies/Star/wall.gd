extends Area2D

@export var wall_number: int

var star: Star

@onready var wall_sprite_2d: Sprite2D = $WallSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	star = owner as Star
	assert(star != null, "The state type must be used only in the Star scene. It needs the owner to be a Star node.")

	set_collision_layer_value(Globals.CollisionLayer.ENEMIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BOUNDARIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BULLETS, true)
	self.area_entered.connect(_on_area_entered)
	_set_sprite_colour()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _set_sprite_colour() -> void:
	match star.wall_colours[wall_number]:
		Globals.Colour.BLUE:
			wall_sprite_2d.texture = load("res://Enemies/Colours/Blue/enemy_blue.png")
		Globals.Colour.GREEN:
			wall_sprite_2d.texture = load("res://Enemies/Colours/Green/enemy_green.png")
		Globals.Colour.RED:
			wall_sprite_2d.texture = load("res://Enemies/Colours/Red/enemy_red.png")


func _on_area_entered(area: Area2D) -> void:
	var bullet = area as Bullet
	if bullet.colour != star.wall_colours[wall_number]:
		return
	queue_free()
