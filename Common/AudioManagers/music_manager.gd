extends Node2D

var music_audio: Dictionary = {}

var swell_base = music_audio.get("SwellBase")

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is AudioStreamPlayer2D:
			music_audio[child.name] = child

func play_music():
	if !swell_base.is_playing():
		swell_base.play("SwellBase")
	
func stop_sound(audio_stream_string: String):
	if music_audio.has(audio_stream_string):
		music_audio.get(audio_stream_string).stop()

func is_playing(audio_stream: String) -> bool:
	if music_audio.has(audio_stream):
		return music_audio.get(audio_stream).playing
	else:
		return false
