class_name Player
extends CharacterBody2D

const PLAYER_UPGRADE_BUTTON = preload("res://Player/Upgrades/player_upgrade_button.tscn")
const CONDITION_LABEL = preload("res://Player/Conditions/condition_label.tscn")
const GUN_PARTICLES = preload("res://Player/VFX/gun_particles.tscn")
const TASER_PARTICLES = preload("res://Player/VFX/taser_particles.tscn")
const AFTER_IMAGE_PARTICLES = preload("res://Player/VFX/after_image_particles.tscn")
const PLAYER_DEATH_PARTICLES = preload("res://Player/VFX/player_death_particles.tscn")

var base_health := 3
var health: int
var base_move_speed := 300.0
var move_speed := base_move_speed
var current_colour := Globals.Colour.BLUE

var max_upgrades: int = 8
var upgrades: Array[Upgrade] = []
var conditions: Array[Condition] = []
var points: int = 1

var tutorial_movement_controls: bool = true
var tutorial_colour_controls: bool = true
var tutorial_colour_reload_controls: bool = true

var controls_enabled: bool = true
var shield_active: bool = false
var taser_particles_enabled: bool = false

var gun_cooldown: float = 0.7
var gun_switch_cooldown: float = 0.3
var hit_immunity_time: float = 1.0

@onready var bullet_spawn_point: Node2D = $PlayerSprite/BulletSpawnPoint
@onready var tip_of_barrel_point: Node2D = $PlayerSprite/TipOfBarrelPoint
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hurt_box: Area2D = $HurtBox
@onready var muzzle_flash: Sprite2D = $PlayerSprite/BulletSpawnPoint/MuzzleFlash

@onready var player_sprite: PlayerSprite = $PlayerSprite
@onready var palette: Palette = $Palette
@onready var shield_sprite: Sprite2D = $ShieldSprite
@onready var health_bar_inner: Sprite2D = $HealthBar/HealthBarInner
@onready var health_label: Label = $HealthBar/HealthLabel

@onready var gun_cooldown_timer: Timer = $GunCooldownTimer
@onready var gun_switch_cooldown_timer: Timer = $GunSwitchCooldownTimer
@onready var hit_immunity_timer: Timer = $HitImmunityTimer
@onready var switch_colour_flash: Sprite2D = $SwitchColourFlash
@onready var after_image_timer: Timer = $AfterImageTimer
@onready var stun_grenade_overlay: Sprite2D = $StunGrenadeOverlay
@onready var exosuit_overdrive_aura: Sprite2D = $ExosuitOverdriveAura

@onready var chrome_knuckles_proximity: Area2D = $ChromeKnucklesProximity
@onready var player_conditions_interface: VBoxContainer = $PlayerInterface/PlayerConditionsInterface
@onready var player_upgrades_interface: HBoxContainer = $PlayerInterface/PlayerUpgradesInterface
@onready var player_points_label: Label = $PlayerInterface/PlayerPoints/PlayerPointsLabel
@onready var player_hit_overlay: Sprite2D = $PlayerInterface/PlayerHitOverlay


func _init() -> void:
	Globals.player = self


func _ready() -> void:
	SignalBus.upgrade_removed.connect(remove_upgrade)
	set_health(base_health)
	base_health += floori(Save.lifetime_palettes / 100)
	gun_cooldown = 1 / (1 / gun_cooldown * (1 + Save.lifetime_palettes * 0.002))
	player_sprite.set_colour(current_colour)
	Globals.set_crosshair_colour(current_colour)
	palette.generate_new_palette()
	player_points_label.text = str(points)
	player_hit_overlay.modulate.a = 0
	switch_colour_flash.modulate.a = 0
	muzzle_flash.modulate.a = 0


func _process(delta: float) -> void:
	muzzle_flash.modulate.a = lerp(muzzle_flash.modulate.a, 0.0, delta * 30.0)
	switch_colour_flash.modulate.a = lerp(switch_colour_flash.modulate.a, 0.0, delta * 5.0)
	switch_colour_flash.scale = lerp(switch_colour_flash.scale, Vector2(1.0, 1.0), delta * 5.0)

	if player_hit_overlay.modulate.a > 0:
		player_hit_overlay.modulate.a -= delta

	if stun_grenade_overlay.modulate.a > 0.0:
		stun_grenade_overlay.modulate.a = lerp(stun_grenade_overlay.modulate.a, 0.0, delta / 0.2)
		stun_grenade_overlay.scale = lerp(stun_grenade_overlay.scale, Vector2(1.0, 1.0), delta / 0.3)

	if exosuit_overdrive_aura.visible:
		exosuit_overdrive_aura.modulate.a = lerp(exosuit_overdrive_aura.modulate.a, 0.1, delta / 0.2)
		exosuit_overdrive_aura.scale = lerp(exosuit_overdrive_aura.scale, Vector2(0.75, 0.75), delta / 0.2)
		if exosuit_overdrive_aura.modulate.a < 0.15:
			exosuit_overdrive_aura.modulate.a = 0.3
			exosuit_overdrive_aura.scale = Vector2(0.8, 0.8)

	shield_sprite.visible = true if shield_active else false
	if !hit_immunity_timer.is_stopped():  # Hit immunity flashing
		player_sprite.set_light_visibility(false)
		if roundi(hit_immunity_timer.time_left * 10) % 2 == 0:
			player_sprite.set_light_visibility(true)
	else:
		player_sprite.set_light_visibility(true)

	var move_vec = Vector2(0, 0)
	if controls_enabled and tutorial_movement_controls:
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
	if controls_enabled and tutorial_movement_controls:
		player_sprite.rotation = (get_global_mouse_position() - global_position).angle()
		collision_shape_2d.rotation = (get_global_mouse_position() - global_position).angle() + deg_to_rad(24)
		hurt_box.rotation = (get_global_mouse_position() - global_position).angle() + deg_to_rad(24)

	move_and_slide()


func _input(_event: InputEvent) -> void:
	if controls_enabled and tutorial_colour_controls:
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
		if Input.is_action_just_pressed("player_reload") and tutorial_colour_reload_controls:
			palette.reload_palette()


func _fire_bullet():
	if !gun_cooldown_timer.is_stopped():
		return

	var gun_angle = (tip_of_barrel_point.global_position - bullet_spawn_point.global_position).angle()
	var angle: float = clamp((get_global_mouse_position() - bullet_spawn_point.global_position).angle(), gun_angle + deg_to_rad(2), gun_angle + deg_to_rad(5))
	var new_bullet: Bullet
	new_bullet = Bullet.create(bullet_spawn_point.global_position, angle, current_colour)

	if taser_particles_enabled:
		var taser_particles = TASER_PARTICLES.instantiate()
		taser_particles.emitting = true
		bullet_spawn_point.add_child(taser_particles)

	muzzle_flash.modulate = Globals.COLOUR_VISUAL_VALUE[current_colour]
	muzzle_flash.modulate.a = 1.0
	ScreenShaker.shake(0.05, 5.0)
	player_sprite.play_shoot_animation()
	SfxManager.play_sound("ShootingSFX", -30.0, -28.0, 1.0, 1.2)
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

	var log_context_data = {"current_gun_colour": Globals.COLOUR_STRING[current_colour], "new_gun_colour": Globals.COLOUR_STRING[new_colour]}
	var log_play_data = {"message": "Gun colour switched", "context": log_context_data}
	Logger.log_play_data(log_play_data)

	current_colour = new_colour
	player_sprite.set_colour(current_colour)
	switch_colour_flash.scale = Vector2(0.1, 0.1)
	switch_colour_flash.modulate = Globals.COLOUR_VISUAL_VALUE[current_colour]
	switch_colour_flash.modulate.a = 1.0
	Globals.set_crosshair_colour(current_colour)
	player_sprite.play_change_colour_animation()
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
	if health <= 0:
		health_bar_inner.visible = false
	else:
		health_bar_inner.visible = true
	var health_bar_inner_gradient = health_bar_inner.texture as GradientTexture2D
	health_bar_inner_gradient.width = clampf(float(health) / base_health * 64.0, 1, 64.0)
	health_label.text = str(health)


func _on_hurt_box_area_entered(_area: Area2D) -> void:
	player_hit(_area.owner as Enemy)


func player_hit(enemy: Enemy) -> void:
	if !hit_immunity_timer.is_stopped() or health <= 0:
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

	ConditionManager.on_player_received_damage()
	set_health(health - enemy.damage)
	player_hit_overlay.modulate.a = 1
	player_hit_overlay.visible = true
	ScreenFreezer.freeze(0.2)
	ScreenShaker.shake(0.2, 20.0)
	log_context_data.merge({"enemy_damage": enemy.damage, "player_health": health})
	SfxManager.play_sound("PlayerHitSFX", -15.0, -13.0, 0.9, 1.1)
	var log_play_data = {"message": "Player hit", "context": log_context_data}
	Logger.log_play_data(log_play_data)

	if health <= 0:
		set_health(0)
		log_play_data = {"message": "Player killed", "context": log_context_data}
		Logger.log_play_data(log_play_data)
		SfxManager.play_sound("PlayerHitSFX", -15.0, -13.0, 0.9, 1.1)
		visible = false
		var player_death_particles = PLAYER_DEATH_PARTICLES.instantiate()
		player_death_particles.emitting = true
		player_death_particles.global_position = global_position
		get_tree().root.add_child(player_death_particles)
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


func enable_taser_particles(enabled: bool) -> void:
	taser_particles_enabled = enabled


func enable_after_image(enabled: bool) -> void:
	if enabled:
		after_image_timer.start(0.2)
	else:
		after_image_timer.stop()


func _on_after_image_timer_timeout() -> void:
	var after_image_particles = AFTER_IMAGE_PARTICLES.instantiate()
	after_image_particles.global_position = global_position
	after_image_particles.emitting = true
	get_tree().root.add_child(after_image_particles)


func display_stun_grenade_overlay() -> void:
	stun_grenade_overlay.modulate.a = 1.0
	stun_grenade_overlay.scale = Vector2(0.0, 0.0)


func enable_exosuit_overdrive_aura(enabled: bool) -> void:
	if enabled:
		exosuit_overdrive_aura.visible = true
	else:
		exosuit_overdrive_aura.visible = false
