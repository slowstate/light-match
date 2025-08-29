class_name Tutorial
extends Node2D

const BOT = preload("res://Enemies/Bot/bot.tscn")

var ARENA = load("res://Arena/arena.tscn")
var MAIN_MENU = load("res://Menus/MainMenu/main_menu.tscn")

var dialogue_strings: Array[String] = [
	"TUTORIAL_INTRO_1",  # "Hello"
	"TUTORIAL_INTRO_2",  # "Welcome to Test Facility 003"
	"TUTORIAL_INTRO_3",  # "I am 4DM1N-D2 and I will be your training coordinator"
	"TUTORIAL_MOVEMENT_1",  # "First, let's test your basic motor functions"
	"TUTORIAL_MOVEMENT_2",  # "In a moment, I will create a target - destroy it"
	"TUTORIAL_MOVEMENT_3",  # "Press W, A, S, D to move around, mouse to aim, and left-click to fire your gun"
	"TUTORIAL_COLOURS_1",  # "Hm, guess that doesn't work. Try matching colours with the target"
	"TUTORIAL_COLOURS_2",  # "Press 1, 2, and 3, or scroll your mouse wheel to change your colour"
	"TUTORIAL_SEQUENCE_1",  # "That worked. Next, let's calibrate your optic algorithm"
	"TUTORIAL_SEQUENCE_2",  # "See those hexagons above your head? Together they're called a Sequence"
	"TUTORIAL_SEQUENCE_3",  # "Destroy targets that match the colour of each hexagon from left to right to complete the Sequence"
	"TUTORIAL_SEQUENCE_4",  # "For every Sequence you complete, you get closer to unlocking your evolutionary potential"
	"TUTORIAL_SEQUENCE_5",  # "Try to complete a Sequence by destroying this target"
	"TUTORIAL_SEQUENCE_6",  # "Too bad, you failed to complete the Sequence because the target was the wrong colour"
	"TUTORIAL_SEQUENCE_7",  # "If the Sequence doesn't match the colour of the targets, you can refresh it by pressing R. Give it try"
	"TUTORIAL_SEQUENCE_8",  # "Looks like you've got the hang of it now"
]

var dialogue_index: int = 0

@onready var music_manager: Node2D = $MusicManager
@onready var player: Player = $Player
@onready var dialogue_timer: Timer = $DialogueTimer
@onready var dialogue_label: Label = $BotSprite/DialogueLabel
@onready var bot_respawn_timer: Timer = $BotRespawnTimer
@onready var fade: ColorRect = $Fade
@onready var fade_in_timer: Timer = $FadeInTimer
@onready var fade_out_timer: Timer = $FadeOutTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !SignalBus.enemy_hit_with_wrong_colour.is_connected(_on_enemy_hit_with_wrong_colour):
		SignalBus.enemy_hit_with_wrong_colour.connect(_on_enemy_hit_with_wrong_colour)
	if !SignalBus.enemy_died.is_connected(_on_enemy_died):
		SignalBus.enemy_died.connect(_on_enemy_died)
	if !SignalBus.palette_cleared.is_connected(_on_palette_cleared):
		SignalBus.palette_cleared.connect(_on_palette_cleared)
	if !SignalBus.palette_failed.is_connected(_on_palette_failed):
		SignalBus.palette_failed.connect(_on_palette_failed)

	music_manager.update_music(0.0)

	player.tutorial_movement_controls = false
	player.tutorial_colour_controls = false
	player.tutorial_colour_reload_controls = false
	player.palette.tutorial_palette_enabled = false
	player.palette.visible = false
	player.hurt_box.monitoring = false
	player.player_sprite.rotation = deg_to_rad(-90)
	dialogue_label.text = tr(dialogue_strings[dialogue_index])
	dialogue_timer.start(3)
	fade.visible = true
	fade_in_timer.start(2)


func _process(delta: float) -> void:
	if !fade_in_timer.is_stopped():
		fade.modulate.a = lerp(1.0, 0.0, 1 - fade_in_timer.time_left / fade_in_timer.wait_time)
	if !fade_out_timer.is_stopped():
		fade.modulate.a = lerp(0.0, 1.0, 1 - fade_out_timer.time_left / fade_out_timer.wait_time)


func update_dialogue() -> void:
	dialogue_index += 1
	dialogue_label.text = tr(dialogue_strings[dialogue_index])
	dialogue_timer.start(2 + tr(dialogue_strings[dialogue_index]).length() / 20)


func _on_dialogue_timer_timeout() -> void:
	if dialogue_index == 4:
		spawn_enemy(Globals.Colour.RED)
		player.tutorial_movement_controls = true
	if dialogue_index == 5:
		return
	if dialogue_index == 6:
		player.tutorial_colour_controls = true
	if dialogue_index == 7:
		return
	if dialogue_index == 8:
		player.palette.tutorial_palette_enabled = true
		player.palette.visible = true
	if dialogue_index == 12:
		var enemy_possible_colours = Globals.Colour.values()
		enemy_possible_colours.erase(player.palette.palette_colours[player.palette.current_palette_colour_index])
		spawn_enemy(enemy_possible_colours.pick_random())
		return
	if dialogue_index == 13:
		var enemy_possible_colours = Globals.Colour.values()
		enemy_possible_colours.erase(player.palette.palette_colours[player.palette.current_palette_colour_index])
		spawn_enemy(enemy_possible_colours.pick_random())
		spawn_enemy(enemy_possible_colours.pick_random(), true, Vector2(1280 - 128, 720 + 150))
		spawn_enemy(enemy_possible_colours.pick_random(), true, Vector2(1280, 720 + 150))
		player.tutorial_colour_reload_controls = true
	if dialogue_index == 14:
		return
	if dialogue_index == 15:
		fade_out_timer.start(3)
		return
	update_dialogue()


func _on_enemy_hit_with_wrong_colour(enemy: Enemy) -> void:
	if dialogue_index == 5:
		update_dialogue()


func _on_enemy_died(enemy: Enemy) -> void:
	if dialogue_index == 7:
		update_dialogue()
	if dialogue_index == 12:
		update_dialogue()


func _on_palette_cleared() -> void:
	if dialogue_index == 14:
		update_dialogue()


func _on_palette_failed() -> void:
	if dialogue_index == 14:
		dialogue_label.text = tr("TUTORIAL_SEQUENCE_FAILED")  # "Not quite, give it another try. Press R to refresh the Sequence"
		for bot in get_tree().get_nodes_in_group("Bots"):
			bot.queue_free()
		bot_respawn_timer.start(3.1)


func spawn_enemy(colour: Globals.Colour, dumdum: bool = true, location: Vector2 = Vector2(1280 + 128, 720 + 150)) -> void:
	var new_enemy = Bot.create(location, 2, colour)
	new_enemy.dumdum = dumdum
	add_child(new_enemy)


func _on_bot_respawn_timer_timeout() -> void:
	var enemy_possible_colours = Globals.Colour.values()
	enemy_possible_colours.erase(player.palette.palette_colours[player.palette.current_palette_colour_index])
	spawn_enemy(enemy_possible_colours.pick_random())
	spawn_enemy(enemy_possible_colours.pick_random(), true, Vector2(1280 - 128, 720 + 150))
	spawn_enemy(enemy_possible_colours.pick_random(), true, Vector2(1280, 720 + 150))


func _on_fade_out_timer_timeout() -> void:
	Save.lifetime_palettes += 1
	get_tree().change_scene_to_packed(MAIN_MENU)
