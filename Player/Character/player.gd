class_name Player
extends CharacterBody2D

const PLAYER_UPGRADE_BUTTON = preload("res://Player/Upgrades/player_upgrade_button.tscn")
const BiggerBullet = preload("res://Player/Upgrades/bigger_bullet.gd")
const BigBullet = preload("res://Player/Upgrades/big_bullet.gd")
const Bipod = preload("res://Player/Upgrades/bipod.gd")
const ChargedAmmo = preload("res://Player/Upgrades/charged_ammo.gd")
const ChromeKnuckles = preload("res://Player/Upgrades/chrome_knuckles.gd")
const FreezeBomb = preload("res://Player/Upgrades/freeze_bomb.gd")
const PowerDiverter = preload("res://Player/Upgrades/power_diverter.gd")

var base_move_speed := 500.0
var move_speed := base_move_speed
var current_colour := Globals.Colour.BLUE
var upgrades: Array[Upgrade] = []
var controls_enabled: bool = true
var move_vec: Vector2
var shield: bool = false

var gun_cooldown: float = 0.7
var gun_switch_cooldown: float = 0.5

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var camera_2d: Camera2D = $Camera2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var palette: Palette = $Palette
@onready var gun_cooldown_timer: Timer = $GunCooldownTimer
@onready var gun_switch_cooldown_timer: Timer = $GunSwitchCooldownTimer
@onready var chrome_knuckles_proximity: Area2D = $ChromeKnucklesProximity
@onready var player_upgrades_interface: HBoxContainer = $PlayerInterface/PlayerUpgradesInterface
@onready var hit_immunity_timer: Timer = $HitImmunityTimer


func _init() -> void:
	Globals.player = self


func _ready() -> void:
	SignalBus.upgrade_removed.connect(remove_upgrade)
	#add_upgrades([PowerDiverter.new()])


func _physics_process(_delta: float) -> void:
	var sprite_gradient_texture: GradientTexture2D = sprite_2d.texture
	if !hit_immunity_timer.is_stopped():
		sprite_gradient_texture.gradient.colors[0] = Color.WHITE if roundi(hit_immunity_timer.time_left * 10) % 2 == 0 else Color.RED

	move_vec = move_vec.normalized()

	if move_vec.length() > 0:
		UpgradeManager.on_player_moving()

	velocity = move_vec * move_speed
	sprite_2d.rotation = (get_global_mouse_position() - global_position).angle()
	collision_shape_2d.rotation = -velocity.angle()

	move_and_slide()


func _input(event: InputEvent) -> void:
	move_vec = Vector2(0, 0)
	if !controls_enabled:
		return

	# Handle movement
	if Input.is_action_pressed("player_move_up"):
		move_vec.y = -1
	if Input.is_action_pressed("player_move_left"):
		move_vec.x = -1
	if Input.is_action_pressed("player_move_down"):
		move_vec.y = 1
	if Input.is_action_pressed("player_move_right"):
		move_vec.x = 1

	# Handle colour switching
	if event.is_action_pressed("player_red"):
		change_colour(Globals.Colour.RED)
	if event.is_action_pressed("player_green"):
		change_colour(Globals.Colour.GREEN)
	if event.is_action_pressed("player_blue"):
		change_colour(Globals.Colour.BLUE)
	if event.is_action_pressed("player_next_colour"):
		_get_next_colour()
	if event.is_action_pressed("player_previous_colour"):
		_get_previous_colour()

	# Handle shooting
	if event.is_action_pressed("player_shoot") && gun_cooldown_timer.is_stopped():
		_fire_bullet()


func _fire_bullet():
	if !gun_cooldown_timer.is_stopped():
		return
	var direction_vector: Vector2 = (get_global_mouse_position() - global_position).normalized()
	var new_bullet: Bullet
	match current_colour:
		Globals.Colour.BLUE:
			new_bullet = BlueBullet.create(global_position, direction_vector)
		Globals.Colour.GREEN:
			new_bullet = GreenBullet.create(global_position, direction_vector)
		Globals.Colour.RED:
			new_bullet = RedBullet.create(global_position, direction_vector)
	if new_bullet:
		new_bullet = UpgradeManager.on_bullet_fired(new_bullet)
		get_tree().root.add_child(new_bullet)
		gun_cooldown_timer.wait_time = 0.7
		gun_cooldown_timer = UpgradeManager.on_gun_cooldown_start(gun_cooldown_timer)
		gun_cooldown_timer.start()


func _get_next_colour() -> void:
	var bullet_colours = Globals.Colour.values()
	if current_colour == Globals.Colour.RED:
		change_colour(Globals.Colour.BLUE)
	else:
		change_colour(bullet_colours[bullet_colours.find(current_colour) + 1])


func _get_previous_colour() -> void:
	var bullet_colours = Globals.Colour.values()
	if current_colour == Globals.Colour.BLUE:
		change_colour(Globals.Colour.RED)
	else:
		change_colour(bullet_colours[bullet_colours.find(current_colour) - 1])


func change_colour(new_colour: Globals.Colour) -> void:
	if !gun_switch_cooldown_timer.is_stopped():
		return
	if current_colour == new_colour:
		return
	current_colour = new_colour
	var sprite_gradient_texture: GradientTexture2D = sprite_2d.texture
	sprite_gradient_texture.gradient.colors[0] = Globals.COLOUR_VISUAL_VALUE[current_colour]
	gun_switch_cooldown_timer.start(gun_switch_cooldown)
	gun_cooldown_timer = UpgradeManager.on_gun_colour_switch(gun_cooldown_timer)


func add_upgrades(new_upgrades: Array[Upgrade]) -> void:
	if upgrades.size() <= 5 and upgrades.size() + new_upgrades.size() <= 5:
		upgrades.append_array(new_upgrades)
		update_player_upgrades_interface()


func remove_upgrade(upgrade: Upgrade) -> void:
	UpgradeManager.on_upgrade_removed(upgrade)
	if upgrades.find(upgrade) >= 0:
		upgrades.erase(upgrade)
		update_player_upgrades_interface()


func update_player_upgrades_interface() -> void:
	# Clear all player upgrades displayed in the interface
	for upgrade_button in player_upgrades_interface.get_children():
		player_upgrades_interface.remove_child(upgrade_button)
		upgrade_button.queue_free()

	for upgrade in upgrades:
		var new_upgrade_button: PlayerUpgradeButton = PLAYER_UPGRADE_BUTTON.instantiate()
		new_upgrade_button.custom_minimum_size = Vector2(80, 80)
		new_upgrade_button.setup(upgrade)
		player_upgrades_interface.add_child(new_upgrade_button)


func enable_player_upgrade_buttons(enable: bool) -> void:
	for upgrade_button in player_upgrades_interface.get_child_count():
		var button = player_upgrades_interface.get_child(upgrade_button) as PlayerUpgradeButton
		button.disabled = !enable


func _on_hurt_box_area_entered(_area: Area2D) -> void:
	if !hit_immunity_timer.is_stopped():
		return
	hit_immunity_timer.start(1)
	if shield:
		print("Shield triggered")
		shield = false
		return
	if upgrades.size() <= 0:
		print("Player died")
		SignalBus.player_died.emit()
		return
	remove_upgrade(upgrades.back())
