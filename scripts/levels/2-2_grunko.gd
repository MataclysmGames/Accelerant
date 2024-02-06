extends Node2D

@export var theme : AudioStream
@onready var cutscene_trigger = $CutsceneTrigger
@onready var player : PlatformPlayer = $Player
@onready var status_label : Label = $StatusLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	BackgroundAudio.play_audio(theme, -10, 0.5)
	cutscene_trigger.trigger.connect(on_trigger)
	GlobalEventBus.message.connect(handle_message)
	
func on_trigger(cutscene_name : String):
	BackgroundAudio.play_audio(theme, -80, 0.5)
	player.sprite.stop()
	player.show_dialogue_scene(cutscene_name)
	
func handle_message(message : String, _sender : String):
	if message == "clippy_reveal_end":
		status_label.text = "Critical"
		BackgroundAudio.play_audio(theme, -10, 1.3, 0.2)
		player.permanently_disable()
		player.sprite.play()
		player.camera.limit_right = 1392
		player.camera.limit_top = -64
		var tween = create_tween()
		tween.tween_property(player, "position", Vector2(176, 80), 2)
		tween.tween_property(player, "velocity", Vector2(1200, -10), 0.1)
		tween.tween_interval(1)
		tween.tween_callback(func(): player.permanently_enable())
