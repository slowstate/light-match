extends Appendage

var oracle: Oracle
var original_position: Vector2 = position


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	oracle = owner as Oracle
	assert(oracle != null, "The state type must be used only in the Oracle scene. It needs the owner to be a Oracle node.")

	self.area_entered.connect(_on_area_entered)
	set_colour(oracle.orb_colour)
