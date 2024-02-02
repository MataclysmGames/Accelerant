extends Node2D

@onready var audio_stream_player : AudioStreamPlayer = $AudioStreamPlayer

var current_audio_resource = "none"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func play_audio(audio : AudioStream, volume : float = 0.0, pitch : float = 1.0):
	if not audio:
		return
	if audio.resource_path == current_audio_resource:
		audio_stream_player.create_tween().tween_property(audio_stream_player, "volume_db", volume, 2)
		audio_stream_player.create_tween().tween_property(audio_stream_player, "pitch_scale", pitch, 2)
	else:
		current_audio_resource = audio.resource_path
		var tween = audio_stream_player.create_tween()
		if audio_stream_player.playing:
			tween.tween_property(audio_stream_player, "volume_db", -100, 2)
		tween.tween_callback(func(): audio_stream_player.stream = audio)
		tween.tween_callback(func(): audio_stream_player.volume_db = -20)
		tween.tween_callback(func(): audio_stream_player.pitch_scale = pitch)
		tween.tween_callback(audio_stream_player.play)
		tween.tween_property(audio_stream_player, "volume_db", volume, 2)
		
func stop_audio(fade_duration : float = 1.0):
	current_audio_resource = "none"
	var tween = audio_stream_player.create_tween()
	tween.tween_property(audio_stream_player, "volume_db", -100, fade_duration)
	tween.tween_callback(audio_stream_player.stop)
