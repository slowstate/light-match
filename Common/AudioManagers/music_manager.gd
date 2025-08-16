extends Node2D

@onready var swell_base: AudioStreamPlayer = $SwellBase
@onready var bass_base: AudioStreamPlayer = $BassBase
@onready var bass_bot: AudioStreamPlayer = $BassBot
@onready var beat_base: AudioStreamPlayer = $BeatBase
@onready var beat_liz: AudioStreamPlayer = $BeatLiz
@onready var drums_base: AudioStreamPlayer = $DrumsBase
@onready var drums_tank: AudioStreamPlayer = $DrumsTank
@onready var highlight_base: AudioStreamPlayer = $HighlightBase
@onready var highlight_oracle: AudioStreamPlayer = $HighlightOracle
@onready var lead_base: AudioStreamPlayer = $LeadBase
@onready var lead_star: AudioStreamPlayer = $LeadStar
var current_state: State
var enemy_types_to_spawn: Array[Globals.EnemyType]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

	
func update_music(play_time: float):
	if get_parent() is Arena:
		enemy_types_to_spawn = get_parent().enemy_types_to_spawn
		update_volume(-5.0)
		swell_base.play(play_time)
		for enemy_type in enemy_types_to_spawn:
			if enemy_type == 0:
				bass_bot.play(play_time)
				bass_base.stop()
			else:
				bass_base.play(play_time)
				bass_bot.stop()
			if enemy_type == 1:
				beat_liz.play(play_time)
				beat_base.stop()
			else:
				beat_base.play(play_time)
				beat_liz.stop()
			if enemy_type == 2:
				drums_tank.play(play_time)
				drums_base.stop()
			else:
				drums_base.play(play_time)
				drums_tank.stop()
			if enemy_type == 3:
				highlight_oracle.play(play_time)
				highlight_base.stop()
			else:
				highlight_base.play(play_time)
				highlight_oracle.stop()
			if enemy_type == 4:
				lead_star.play(play_time)
				lead_base.stop()
			else:
				lead_base.play(play_time)
				lead_star.stop()
	else:
		update_volume(-7.0)
		swell_base.play(play_time)
		bass_base.play(play_time)
		beat_base.play(play_time)
		drums_base.play(play_time)
		highlight_base.play(play_time)
		lead_base.play(play_time)

func update_volume(volume_db: float):
	var music_volume = volume_db
	swell_base.volume_db = music_volume
	bass_base.volume_db = music_volume
	bass_bot.volume_db = music_volume
	beat_base.volume_db = music_volume
	beat_liz.volume_db = music_volume
	drums_base.volume_db = music_volume
	drums_tank.volume_db = music_volume
	highlight_base.volume_db = music_volume
	highlight_oracle.volume_db = music_volume
	lead_base.volume_db = music_volume
	lead_star.volume_db = music_volume
