extends Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !self.timeout.is_connected(_on_timeout):
		self.timeout.connect(_on_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func screen_freeze(duration: float = 0.1) -> void:
	get_tree().paused = true
	start(duration)


func _on_timeout() -> void:
	get_tree().paused = false
