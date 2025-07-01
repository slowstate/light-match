extends Node

enum CollisionLayer { BOUNDARIES = 1, PLAYER = 2, BULLETS = 3, ENEMIES = 4, TANK_SHIELD = 5, ENEMY_SOCIAL_DISTANCING = 6, CHROME_KNUCKLES = 7 }
enum Colour { BLUE = 1, GREEN = 2, RED = 3 }
enum EnemyType { BOT, LIZARD, TANK, ORACLE, STAR }

const CROSSHAIR_HALF_BLUE = preload("res://HUD/Crosshair Half Blue.png")
const CROSSHAIR_HALF_GREEN = preload("res://HUD/Crosshair Half Green.png")
const CROSSHAIR_HALF_RED = preload("res://HUD/Crosshair Half Red.png")

const COLOUR_STRING: Dictionary = {Colour.BLUE: "Blue", Colour.RED: "Red", Colour.GREEN: "Green"}
const _COLOUR_VISUAL_VALUE_BLUE: Color = Color(0.0118, 0.6275, 1, 1)
const _COLOUR_VISUAL_VALUE_GREEN: Color = Color(0, 0.93, 0, 1)
const _COLOUR_VISUAL_VALUE_RED: Color = Color.ORANGE_RED
const COLOUR_VISUAL_VALUE: Dictionary = {Colour.BLUE: _COLOUR_VISUAL_VALUE_BLUE, Colour.GREEN: _COLOUR_VISUAL_VALUE_GREEN, Colour.RED: _COLOUR_VISUAL_VALUE_RED}
const ENEMY_TYPE_GROUP: Dictionary = {
	EnemyType.BOT: "Bots", EnemyType.LIZARD: "Lizards", EnemyType.TANK: "Tanks", EnemyType.ORACLE: "Oracles", EnemyType.STAR: "Stars"
}

var player: Player


func pick_random_colour(pickable_colours: Array[Colour] = [Colour.BLUE, Colour.GREEN, Colour.RED]) -> Colour:
	return pickable_colours.pick_random()


func generate_guid(length: int = 36):
	var chars = "abcdefghijklmnopqrstuvwxyz"
	var word: String = ""
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi() % n_char]
	return word + Time.get_datetime_string_from_system()


func get_all_enemies_alive() -> Array[Enemy]:
	var all_enemies_alive: Array[Enemy] = []
	all_enemies_alive.append_array(get_tree().get_nodes_in_group(ENEMY_TYPE_GROUP[EnemyType.BOT]))
	all_enemies_alive.append_array(get_tree().get_nodes_in_group(ENEMY_TYPE_GROUP[EnemyType.LIZARD]))
	all_enemies_alive.append_array(get_tree().get_nodes_in_group(ENEMY_TYPE_GROUP[EnemyType.TANK]))
	all_enemies_alive.append_array(get_tree().get_nodes_in_group(ENEMY_TYPE_GROUP[EnemyType.ORACLE]))
	all_enemies_alive.append_array(get_tree().get_nodes_in_group(ENEMY_TYPE_GROUP[EnemyType.STAR]))
	return all_enemies_alive


func get_all_bullets_active() -> Array[Bullet]:
	var all_bullets_active: Array[Bullet] = get_tree().get_nodes_in_group("Bullets") as Array[Bullet]
	return all_bullets_active


func set_crosshair_colour(colour: Globals.Colour) -> void:
	match colour:
		Globals.Colour.BLUE:
			Input.set_custom_mouse_cursor(CROSSHAIR_HALF_BLUE, Input.CURSOR_ARROW, Vector2(26, 17))
		Globals.Colour.GREEN:
			Input.set_custom_mouse_cursor(CROSSHAIR_HALF_GREEN, Input.CURSOR_ARROW, Vector2(26, 17))
		Globals.Colour.RED:
			Input.set_custom_mouse_cursor(CROSSHAIR_HALF_RED, Input.CURSOR_ARROW, Vector2(26, 17))
