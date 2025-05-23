extends Node

enum Colour { BLUE = 1, GREEN = 2, RED = 3 }
enum CollisionLayer { BOUNDARIES = 1, PLAYER = 2, BULLETS = 3, ENEMIES = 4 }
enum EnemyTypes { BOT, LIZARD, TANK, ORACLE, STAR }

const _COLOUR_VISUAL_VALUE_BLUE: Color = Color.SKY_BLUE
const _COLOUR_VISUAL_VALUE_GREEN: Color = Color.LIGHT_GREEN
const _COLOUR_VISUAL_VALUE_RED: Color = Color.ORANGE_RED
const COLOUR_VISUAL_VALUE: Dictionary = {Colour.BLUE: _COLOUR_VISUAL_VALUE_BLUE, Colour.GREEN: _COLOUR_VISUAL_VALUE_GREEN, Colour.RED: _COLOUR_VISUAL_VALUE_RED}

var player: Player


func pick_random_colour(pickable_colours: Array[Colour] = [Colour.BLUE, Colour.GREEN, Colour.RED]) -> Colour:
	return pickable_colours.pick_random()
