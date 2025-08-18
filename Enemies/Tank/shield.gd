extends Area2D

var tank: Tank

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	tank = owner as Tank
	assert(tank != null, "The state type must be used only in the Tank scene. It needs the owner to be a Tank node.")
	modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area as Bullet == null:
		return
	#SfxManager.play_sound("TankShieldSFX", -35.0, -33.0, 0.9, 1.0)
	SfxManager.play_sound("EnemyDeathSFX", -30.0, -28.0, 2.5, 2.6)
