extends Upgrade

var is_active: bool


func _init() -> void:
	type = UpgradeManager.UpgradeTypes.BIG_BULLET
	name = "Big Bullet"
	description = "After clearing a palette, your next bullet deals double damage"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func on_palette_cleared(palette: Palette) -> void:
	is_active = true


func on_bullet_fired(bullet: Bullet) -> void:
	if is_active:
		bullet.damage *= 2
	is_active = false
