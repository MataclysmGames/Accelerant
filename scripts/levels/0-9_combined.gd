extends Node2D

@export var theme : AudioStream
@onready var cutscene_trigger = $CutsceneTrigger
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	BackgroundAudio.play_audio(theme, -10, 0.5)
	cutscene_trigger.trigger.connect(on_trigger)
	GlobalEventBus.message.connect(handle_message)
	
func on_trigger(cutscene_name : String):
	BackgroundAudio.play_audio(theme, -80, 0.5)
	player.show_dialogue_scene(cutscene_name)
	
func handle_message(message : String, _sender : String):
	if message == "clippy_reveal_end":
		BackgroundAudio.play_audio(theme, -10, 1.3, 0.2)
