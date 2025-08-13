class_name NewEnemyInformation
extends Control

var enemyType: Globals.EnemyType = Globals.EnemyType.BOT

@onready var bot_sprite: Control = $VBoxContainer/BotSprite
@onready var lizard_sprite: Control = $VBoxContainer/LizardSprite
@onready var tank_sprite: Control = $VBoxContainer/TankSprite
@onready var oracle_sprite: Control = $VBoxContainer/OracleSprite
@onready var star_sprite: Control = $VBoxContainer/StarSprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bot_sprite.visible = false
	lizard_sprite.visible = false
	tank_sprite.visible = false
	oracle_sprite.visible = false
	star_sprite.visible = false

	match enemyType:
		Globals.EnemyType.BOT:
			bot_sprite.visible = true
		Globals.EnemyType.LIZARD:
			lizard_sprite.visible = true
		Globals.EnemyType.TANK:
			tank_sprite.visible = true
		Globals.EnemyType.ORACLE:
			oracle_sprite.visible = true
		Globals.EnemyType.STAR:
			star_sprite.visible = true
