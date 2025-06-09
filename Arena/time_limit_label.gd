extends Label

@onready var time_limit_timer: Timer = $TimeLimitTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = str(floori(time_limit_timer.time_left / 60.0)) + ":" + str(floori(time_limit_timer.time_left) % 60).pad_zeros(2)
