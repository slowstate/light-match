extends Area2D

@onready var head_sprite_2d: Sprite2D = $HeadSprite2D

var lizard: Lizard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	lizard = owner as Lizard
	assert(lizard != null, "The state type must be used only in the Bot scene. It needs the owner to be a Bot node.")

	set_collision_layer_value(Globals.CollisionLayer.Enemies, true)
	set_collision_mask_value(Globals.CollisionLayer.Bullets, true)
	set_collision_mask_value(Globals.CollisionLayer.Boundaries, true)
	self.area_entered.connect(_on_area_entered)
	_set_sprite_colour()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _set_sprite_colour() -> void:
	match lizard.head_colour:
		Globals.Colour.Blue: head_sprite_2d.texture = load("res://Enemies/Colours/Blue/enemy_blue.png")
		Globals.Colour.Green: head_sprite_2d.texture = load("res://Enemies/Colours/Green/enemy_green.png")
		Globals.Colour.Red: head_sprite_2d.texture = load("res://Enemies/Colours/Red/enemy_red.png")


func _on_area_entered(bullet: Bullet) -> void:
	print("lizard head area")
	if bullet.colour != lizard.head_colour: return
	queue_free()
