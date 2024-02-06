extends Node2D

@export var theme : AudioStream
@onready var clippy_cutscene : CutsceneTrigger = $ClippyCutsceneTrigger
@onready var tom_cutscene : CutsceneTrigger = $TomCutsceneTrigger
@onready var player : PlatformPlayer = $Player
@onready var status_label : Label = $StatusLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	BackgroundAudio.play_audio(theme, -10, 0.5)
	clippy_cutscene.trigger.connect(on_clippy_trigger)
	tom_cutscene.trigger.connect(on_tom_trigger)
	GlobalEventBus.message.connect(handle_message)
	
func on_clippy_trigger(cutscene_name : String):
	BackgroundAudio.play_audio(theme, -80, 0.5)
	player.sprite.stop()
	player.show_dialogue_scene(cutscene_name)
	
func on_tom_trigger(cutscene_name : String):
	BackgroundAudio.play_audio(theme, -80, 0.5)
	SceneLightingGlobal.set_dimness(0.8)

func handle_message(message : String, _sender : String):
	if message == "clippy_reveal_end":
		status_label.text = "Critical"
		BackgroundAudio.play_audio(theme, -10, 1.3, 0.2)
		player.permanently_disable()
		player.sprite.play()
		player.camera.limit_right = 2864
		player.camera.limit_bottom = 320
		player.camera.limit_top = 0
		var tween = create_tween()
		tween.tween_property(player, "position", Vector2(176, 80), 2)
		tween.tween_property(player, "velocity", Vector2(700, 0), 0.1)
		tween.tween_interval(2.25)
		tween.tween_callback(func(): player.permanently_enable())
