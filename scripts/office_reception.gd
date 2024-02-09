extends Node2D

@export var theme : AudioStream

func _ready():
	BackgroundAudio.play_audio(theme, -20, 1)
