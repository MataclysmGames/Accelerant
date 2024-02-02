extends Node2D

@export var theme : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	BackgroundAudio.play_audio(theme, -20, 0.9)
