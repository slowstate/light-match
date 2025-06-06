class_name BlueBullet
extends Bullet

const BLUE_BULLET = preload("res://Player/Bullet/Blue/blue_bullet.tscn")


static func create(bullet_position: Vector2, bullet_direction: Vector2, bullet_damage := 1, bullet_speed := 1000.0) -> BlueBullet:
	var new_bullet: BlueBullet = BLUE_BULLET.instantiate()
	new_bullet.global_position = bullet_position
	new_bullet.direction = bullet_direction.normalized()
	new_bullet.damage = bullet_damage
	new_bullet.speed = bullet_speed
	new_bullet.colour = Globals.Colour.BLUE
	return new_bullet


func _setup() -> void:
	self.body_entered.connect(on_body_entered)
	self.area_entered.connect(on_area_entered)
	set_sprite_colour()
