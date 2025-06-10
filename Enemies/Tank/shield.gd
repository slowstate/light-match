extends Area2D

var tank: Tank
var shield_enabled: bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	tank = owner as Tank
	assert(tank != null, "The state type must be used only in the Tank scene. It needs the owner to be a Tank node.")
	set_collision_layer_value(Globals.CollisionLayer.TANK_SHIELD, true)
	set_collision_mask_value(Globals.CollisionLayer.BULLETS, true)
	self.area_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area as Bullet == null:
		return
	animation_player.play("Tank_Beam")


func _on_shield_cooldown_timer_timeout() -> void:
	shield_enabled = !shield_enabled
	_enable_tank_shield(shield_enabled)


func _enable_tank_shield(enable_shield: bool) -> void:
	if enable_shield:
		animation_player.play_backwards("Tank_Fade")
	else:
		animation_player.play("Tank_Fade")

	set_collision_layer_value(Globals.CollisionLayer.TANK_SHIELD, enable_shield)
	set_collision_mask_value(Globals.CollisionLayer.BULLETS, enable_shield)
