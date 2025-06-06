class_name Enemy
extends Area2D

@export var colour: Globals.Colour
@export var health := 1
@export var damage := 1
@export var move_speed := 300.0
@export var rotation_speed := 2.0

var health_label: Label = Label.new()
var desired_rotation: float
var is_frozen: bool = false


static func create(_initial_position: Vector2, _initial_health: int, _initial_colour: Globals.Colour = Globals.pick_random_colour()) -> Enemy:
	assert(null, "This method should be overridden by subclasses.")
	return null


func _ready() -> void:
	# TODO: Remove temporary health label
	health_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	health_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	#health_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP, 0, 0)
	health_label.position = Vector2(-8.5, -21)
	health_label.label_settings = LabelSettings.new()
	health_label.label_settings.font_size = 30
	add_child(health_label)

	set_collision_layer_value(Globals.CollisionLayer.BOUNDARIES, false)
	set_collision_layer_value(Globals.CollisionLayer.ENEMIES, true)
	set_collision_mask_value(Globals.CollisionLayer.BOUNDARIES, false)
	set_collision_mask_value(Globals.CollisionLayer.BULLETS, true)

	self.area_entered.connect(_on_area_entered)
	UpgradeManager.on_enemy_spawned(self)
	_setup()


func _process(delta: float) -> void:
	health_label.text = str(health)
	rotate_to_target(delta, desired_rotation)
	_update(delta)


# This function should be overriden by inheriting classes; no code should be added to this class
func _setup() -> void:
	# Keep this empty as child nodes will override this function
	pass


func _update(_delta: float) -> void:
	pass


func rotate_to_target(delta: float, target_rotation: float) -> void:
	if is_frozen:
		return
	var angle_diff = wrapf(target_rotation - rotation, -PI, PI)
	var max_rotation_delta = rotation_speed * delta
	rotation += clamp(angle_diff, -max_rotation_delta, max_rotation_delta)


func move_forward(delta: float) -> void:
	if is_frozen:
		return
	translate(Vector2(cos(rotation), sin(rotation)) * move_speed * delta)


func player_is_within_distance(distance := 500.0) -> bool:
	return (global_position - Globals.player.global_position).length() < distance


func _on_area_entered(area: Area2D) -> void:
	var bullet = area as Bullet
	bullet.damage = UpgradeManager.on_enemy_hit(bullet, self).damage
	if bullet.colour != colour:
		return
	health -= bullet.damage
	if health <= 0:
		UpgradeManager.on_enemy_killed(self)
		SignalBus.emit_signal("enemy_died", self)
		queue_free()
