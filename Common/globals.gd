extends Node

enum Colour {None, Blue, Green, Red}

func PickRandomColour(pickable_colours: Array[Colour] = [Colour.Blue, Colour.Green, Colour.Red]) -> Colour:
	return pickable_colours.pick_random()

const ColourVisualValue: Dictionary = {
	Colour.Blue: Color.SKY_BLUE,
	Colour.Green: Color.LIGHT_GREEN,
	Colour.Red: Color.ORANGE_RED
}

enum CollisionLayer {
	Boundaries = 1,
	Player = 2,
	Bullets = 3,
	Enemies = 4}

var player: Player
