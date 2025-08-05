class_name Player
extends CharacterBody2D

const PLAYER_UPGRADE_BUTTON = preload("res://Player/Upgrades/player_upgrade_button.tscn")
const CONDITION_LABEL = preload("res://Player/Conditions/condition_label.tscn")
const GUN_PARTICLES = preload("res://Player/VFX/gun_particles.tscn")

var base_health := 3
var health: int
var base_move_speed := 300.0
var move_speed := base_move_speed
var current_colour := Globals.Colour.BLUE

var max_upgrades: int = 8
var upgrades: Array[Upgrade] = []
var conditions: Array[Condition] = []
var points: int = 1

var controls_enabled: bool = true
var shield_active: bool = false

var gun_cooldown: float = 0.7
var gun_switch_cooldown: float = 0.3
var hit_immunity_time: float = 1.0

@onready var bullet_spawn_point: Node2D = $PlayerSprite/BulletSpawnPoint
@onready var tip_of_barrel_point: Node2D = $PlayerSprite/TipOfBarrelPoint
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hurt_box: Area2D = $HurtBox

@onready var player_sprite: PlayerSprite = $PlayerSprite
@onready var palette: Palette = $Palette
@onready var shield_sprite: Sprite2D = $ShieldSprite
@onready var health_bar_inner: Sprite2D = $HealthBar/HealthBarInner

@onready var gun_cooldown_timer: Timer = $GunCooldownTimer
@onready var gun_switch_cooldown_timer: Timer = $GunSwitchCooldownTimer
@onready var hit_immunity_timer: Timer = $HitImmunityTimer

@onready var chrome_knuckles_proximity: Area2D = $ChromeKnucklesProximity
@onready var player_conditions_interface: VBoxContainer = $PlayerInterface/PlayerConditionsInterface
@onready var player_upgrades_interface: HBoxContainer = $PlayerInterface/PlayerUpgradesInterface
@onready var player_points_label: Label = $PlayerInterface/PlayerPoints/PlayerPointsLabel


func _init() -> void:
	Globals.player = self


func _ready() -> void:
	SignalBus.upgrade_removed.connect(remove_upgrade)
	set_health(base_health)
	base_health += floori(Save.lifetime_palettes / 100)
	gun_cooldown = 1 / (1 / gun_cooldown * (1 + Save.lifetime_palettes * 0.005))
	player_sprite.set_colour(current_colour)
	Globals.set_crosshair_colour(current_colour)
	palette.generate_new_palette()
	player_points_label.text = str(points)


func _process(_delta: float) -> void:
	shield_sprite.visible = true if shield_active else false
	if !hit_immunity_timer.is_stopped():  # Hit immunity flashing
		player_sprite.set_light_visibility(false)
		if roundi(hit_immunity_timer.time_left * 10) % 2 == 0:
			player_sprite.set_light_visibility(true)
	else:
		player_sprite.set_light_visibility(true)

	var move_vec = Vector2(0, 0)
	if controls_enabled:
		# Handle movement
		if Input.is_action_pressed("player_move_up"):
			move_vec.y = -1
		if Input.is_action_pressed("player_move_left"):
			move_vec.x = -1
		if Input.is_action_pressed("player_move_down"):
			move_vec.y = 1
		if Input.is_action_pressed("player_move_right"):
			move_vec.x = 1

		# Handle shooting
		if Input.is_action_pressed("player_shoot"):
			_fire_bullet()

	move_vec = move_vec.normalized()

	if move_vec.length() > 0:
		UpgradeManager.on_player_moving(true)
		player_sprite.play_move_animation(true)
	else:
		UpgradeManager.on_player_moving(false)
		player_sprite.play_move_animation(false)

	velocity = move_vec * move_speed
	if controls_enabled:
		player_sprite.rotation = (get_global_mouse_position() - global_position).angle() + deg_to_rad(90)
		collision_shape_2d.rotation = -velocity.angle()

	move_and_slide()


func _physics_process(_delta: float) -> void:
	pass


func _input(_event: InputEvent) -> void:
	# Handle colour switching
	if Input.is_action_pressed("player_red"):
		change_colour(Globals.Colour.RED)
	if Input.is_action_pressed("player_green"):
		change_colour(Globals.Colour.GREEN)
	if Input.is_action_pressed("player_blue"):
		change_colour(Globals.Colour.BLUE)
	if Input.is_action_pressed("player_next_colour"):
		_get_next_colour()
	if Input.is_action_pressed("player_previous_colour"):
		_get_previous_colour()


func _fire_bullet():
	if !gun_cooldown_timer.is_stopped():
		return
	player_sprite.play_shoot_animation()
	SfxManager.play_sound("ShootingSFX", -30.0, -28.0, 1.0, 1.2)
	var gun_angle = (tip_of_barrel_point.global_position - bullet_spawn_point.global_position).angle()
	var angle: float = clamp((get_global_mouse_position() - bullet_spawn_point.global_position).angle(), gun_angle + deg_to_rad(2), gun_angle + deg_to_rad(5))
	var new_bullet: Bullet
	new_bullet = Bullet.create(bullet_spawn_point.global_position, angle, current_colour)
	if new_bullet != null:
		UpgradeManager.on_bullet_fired(new_bullet)
		get_tree().root.add_child(new_bullet)
		gun_cooldown_timer.wait_time = gun_cooldown
		UpgradeManager.on_gun_cooldown_start(gun_cooldown_timer)
		gun_cooldown_timer.start()

		var log_context_data = {"bullet": new_bullet.get_script().get_global_name() + str(new_bullet.get_instance_id())}
		var log_play_data = {"message": "Bullet fired", "context": log_context_data}
		Logger.log_play_data(log_play_data)


func _get_next_colour() -> void:
	var bullet_colours = Globals.Colour.values()
	SfxManager.play_sound("ChangeGunSFX", -15.0, -13.0, 0.95, 1.05)
	if current_colour == Globals.Colour.RED:
		change_colour(Globals.Colour.BLUE)
	else:
		change_colour(bullet_colours[bullet_colours.find(current_colour) + 1])


func _get_previous_colour() -> void:
	var bullet_colours = Globals.Colour.values()
	SfxManager.play_sound("ChangeGunSFX", -15.0, -13.0, 0.95, 1.05)
	if current_colour == Globals.Colour.BLUE:
		change_colour(Globals.Colour.RED)
	else:
		change_colour(bullet_colours[bullet_colours.find(current_colour) - 1])


func change_colour(new_colour: Globals.Colour) -> void:
	if !gun_switch_cooldown_timer.is_stopped():
		return
	if current_colour == new_colour:
		return

	var log_context_data = {"current_gun_colour": Globals.COLOUR_STRING[current_colour], "new_gun_colour": Globals.COLOUR_STRING[new_colour]}
	var log_play_data = {"message": "Gun colour switched", "context": log_context_data}
	Logger.log_play_data(log_play_data)

	current_colour = new_colour
	player_sprite.set_colour(current_colour)
	Globals.set_crosshair_colour(current_colour)
	SfxManager.play_sound("ChangeGunSFX", -15.0, -13.0, 0.95, 1.05)
	gun_switch_cooldown_timer.start(gun_switch_cooldown)
	UpgradeManager.on_gun_colour_switch(gun_cooldown_timer)


func add_upgrade(new_upgrade: Upgrade) -> void:
	SfxManager.play_sound("AddUpgradeSFX", -10.0, -8.0, 0.9, 1.1)
	if upgrades.size() < max_upgrades:
		upgrades.push_back(new_upgrade)
		update_player_upgrades_interface()
		UpgradeManager.on_upgrade_added(new_upgrade)


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


func add_condition(new_condition: Condition) -> void:
	conditions.push_back(new_condition)
	update_player_conditions_interface()
	ConditionManager.on_condition_added(new_condition)


func update_player_conditions_interface() -> void:
	# Clear all player conditions displayed in the interface
	for condition_label in player_conditions_interface.get_children():
		player_conditions_interface.remove_child(condition_label)
		condition_label.queue_free()

	for condition in conditions:
		var new_condition_label := CONDITION_LABEL.instantiate()
		new_condition_label.condition = condition
		player_conditions_interface.add_child(new_condition_label)


func add_end_of_round_points() -> void:
	for condition in conditions:
		add_points(condition.points_per_round)


func add_points(points_to_add: int) -> void:
	points += points_to_add
	player_points_label.text = str(points)


func set_health(new_health: int) -> void:
	health = new_health
	var health_bar_inner_gradient = health_bar_inner.texture as GradientTexture2D
	health_bar_inner_gradient.width = clampf(float(health) / base_health * 64.0, 1, 64.0)


func _on_hurt_box_area_entered(_area: Area2D) -> void:
	player_hit(_area.owner as Enemy)


func player_hit(enemy: Enemy) -> void:
	if !hit_immunity_timer.is_stopped():
		return

	var player_upgrade_strings = []
	for player_upgrade in upgrades:
		player_upgrade_strings.append(player_upgrade.name)
	var log_context_data = {
		"enemy": enemy.get_script().get_global_name() + str(enemy.get_instance_id()),
		"player_upgrades": player_upgrade_strings,
		"player_location": global_position
	}

	UpgradeManager.on_player_hit()
	hit_immunity_timer.start(hit_immunity_time)

	if shield_active:
		var log_play_data = {"message": "Player shield broken", "context": log_context_data}
		Logger.log_play_data(log_play_data)
		UpgradeManager.on_player_shield_break()
		SfxManager.play_sound("ShieldHitSFX", -15.0, -13.0, 0.95, 1.05)
		shield_active = false
		return

	set_health(health - enemy.damage)
	log_context_data.merge({"enemy_damage": enemy.damage, "player_health": health})
	SfxManager.play_sound("PlayerHitSFX", -15.0, -13.0, 0.9, 1.1)
	var log_play_data = {"message": "Player hit", "context": log_context_data}
	Logger.log_play_data(log_play_data)

	if health <= 0:
		log_play_data = {"message": "Player killed", "context": log_context_data}
		Logger.log_play_data(log_play_data)
		SfxManager.play_sound("PlayerHitSFX", -15.0, -13.0, 0.9, 1.1)
		SignalBus.player_died.emit()


func game_over_sequence() -> void:
	controls_enabled = false
	hurt_box.set_deferred("monitoring", false)


func _on_chrome_knuckles_proximity_body_entered(_body: Node2D) -> void:
	for upgrade in upgrades:
		if upgrade.type == UpgradeManager.UpgradeTypes.CHROME_KNUCKLES:
			if chrome_knuckles_proximity.get_overlapping_bodies().size() >= 3:
				upgrade.is_active = true


func _on_chrome_knuckles_proximity_body_exited(_body: Node2D) -> void:
	for upgrade in upgrades:
		if upgrade.type == UpgradeManager.UpgradeTypes.CHROME_KNUCKLES:
			if chrome_knuckles_proximity.get_overlapping_bodies().size() < 3:
				upgrade.is_active = false
