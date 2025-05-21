class_name RedBullet
extends Bullet

const RED_BULLET = preload("res://Player/Bullet/Red/red_bullet.tscn")

static func create(bullet_position: Vector2, bullet_direction: Vector2, bullet_damage := 1, bullet_speed := 1000.0) -> RedBullet:
	var new_bullet: RedBullet = RED_BULLET.instantiate()
	new_bullet.global_position = bullet_position
	new_bullet.direction = bullet_direction.normalized()
	new_bullet.damage = bullet_damage
	new_bullet.speed = bullet_speed
	return new_bullet


func _setup() -> void:
	colour = Globals.Colour.Red
	self.body_entered.connect(_on_body_entered)
	self.area_entered.connect(_on_area_entered)
	super._set_sprite_colour()
