extends Area2D

var tank: Tank

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	tank = owner as Tank
	assert(tank != null, "The state type must be used only in the Tank scene. It needs the owner to be a Tank node.")
	set_collision_layer_value(Globals.CollisionLayer.TANK_SHIELD, true)
	set_collision_mask_value(Globals.CollisionLayer.BULLETS, true)
	sprite_2d.modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if sprite_2d.modulate.a < 1.0:
		sprite_2d.modulate.a += delta


func _on_area_entered(area: Area2D) -> void:
	if area as Bullet == null:
		return
	SfxManager.play_sound("EnemyHitSFX", -25.0, -23.0, 2.0, 2.2)
