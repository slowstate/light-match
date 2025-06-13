extends Node2D

var sfx_audio: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is AudioStreamPlayer:
			sfx_audio[child.name] = child
	print(str(sfx_audio))

func play_sound(audio_stream_string: String, volume_db_min: float = 0.0, volume_db_max: float = 0.0, pitch_scale_min: float = 1.0, pitch_scale_max: float = 1.0):
	var audio_stream = sfx_audio.get(audio_stream_string)
	audio_stream.volume_db = volume_db_min
	audio_stream.volume_db = randf_range(volume_db_min, volume_db_max)
	audio_stream.pitch_scale = randf_range(pitch_scale_min, pitch_scale_max)
	audio_stream.play()
	
func stop_sound(audio_stream_string: String):
	if sfx_audio.has(audio_stream_string):
		sfx_audio.get(audio_stream_string).stop()

func is_playing(audio_stream: String) -> bool:
	if sfx_audio.has(audio_stream):
		return sfx_audio.get(audio_stream).playing
	else:
		return false
