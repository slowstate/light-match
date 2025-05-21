class_name LizardStateIdle
extends State

@onready var idle_timer: Timer = $IdleTimer
@onready var roam_timer: Timer = $RoamTimer

var lizard: Lizard

func enter() -> void:
	lizard = owner as Lizard
	assert(lizard != null, "The state type must be used only in the Bot scene. It needs the owner to be a Bot node.")
	
	idle_timer.timeout.connect(_on_idle_timer_timeout)
	roam_timer.timeout.connect(_on_roam_timer_timeout)
	_set_random_direction()
	roam_timer.start(2.0)
	
func exit() -> void:
	roam_timer.stop()
	idle_timer.stop()
	
func update(_delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	if !lizard: return
	if !Globals.player: return
	
	#_if_player_is_within_distance_then_change_state_to_chasing()
	
	if roam_timer.is_stopped(): return
	
	var velocity = lizard.direction * lizard.MOVE_SPEED
	lizard.rotate(velocity.angle())
	lizard.translate(velocity * delta)

func _on_roam_timer_timeout() -> void:
	idle_timer.start(randf_range(1.5, 2.0))

func _on_idle_timer_timeout() -> void:
	_set_random_direction()
	roam_timer.start(randf_range(0.5, 2.0))
	
func _set_random_direction() -> void:
	var angle = randf() * TAU  # TAU = 2π
	lizard.direction = Vector2(cos(angle), sin(angle))

func _if_player_is_within_distance_then_change_state_to_chasing(distance := 500.0) -> void:
	if (lizard.global_position - Globals.player.global_position).length() < distance:
		transition.emit("Chasing")
