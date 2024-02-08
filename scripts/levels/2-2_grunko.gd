extends Node2D

@export var theme : AudioStream
@onready var clippy_cutscene : CutsceneTrigger = $ClippyCutsceneTrigger
@onready var tom_cutscene : CutsceneTrigger = $TomCutsceneTrigger
@onready var status_label : Label = $StatusLabel

@onready var player : PlatformPlayer = $Player
@onready var clippy : Clippy = $Clippy

# Called when the node enters the scene tree for the first time.
func _ready():
	clippy.modulate = Color(1, 1, 1, 0)
	BackgroundAudio.play_audio(theme, -10, 0.5)
	clippy_cutscene.trigger.connect(on_clippy_trigger)
	tom_cutscene.trigger.connect(on_tom_trigger)
	GlobalEventBus.message.connect(handle_message)
	
func on_clippy_trigger(cutscene_name : String):
	var clippy_tween = create_tween()
	clippy_tween.tween_property(clippy, "modulate", Color(1, 1, 1, 1), 1)
	BackgroundAudio.play_audio(theme, -80, 0.5)
	player.sprite.stop()
	player.show_dialogue_scene(cutscene_name)
	
func on_tom_trigger(_cutscene_name : String):
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
		var clippy_tween = create_tween()
		clippy_tween.tween_property(clippy, "modulate", Color(1, 0, 0, 1), 2)
		var tween = create_tween()
		tween.tween_property(player, "position", Vector2(200, 80), 2)
		tween.tween_property(player, "velocity", Vector2(700, 0), 0.1)
		tween.tween_callback(func(): clippy.can_move = true)
		tween.tween_callback(func(): clippy.speed = 660)
		tween.tween_interval(2)
		tween.tween_callback(func(): clippy.speed = 85)
		tween.tween_callback(func(): player.permanently_enable())
	elif message == "chapter_2_finish":
		player.disable_input()
		PlayerLoadPosition.set_player_load_position(Vector2(-8, 0))
		SceneLightingGlobal.fade_in_scene("res://scenes/office/my_office.tscn")
