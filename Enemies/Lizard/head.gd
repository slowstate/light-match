extends Appendage

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.area_entered.connect(_on_area_entered)


func play_attack_animation() -> void:
	animation_player.stop()
	animation_player.play("Liz_Attack")
