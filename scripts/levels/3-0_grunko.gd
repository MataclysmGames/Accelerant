extends Node2D

@export var theme : AudioStream
@onready var player : PlatformPlayer = $Player
@onready var platform_tile_map : TileMap = $PlatformTileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	BackgroundAudio.play_audio(theme, -20, 1)
	GlobalEventBus.message.connect(handle_message)
	if GameState.has_done_action("defragment"):
		platform_tile_map.set_layer_enabled(0, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func handle_message(message : String, _sender : String):
	if message == "defragment":
		var tween = create_tween()
		tween.tween_property(player.camera, "zoom", Vector2(0.44, 0.44), 2)
		tween.tween_interval(0.25)
		tween.tween_callback(func(): platform_tile_map.set_layer_enabled(0, false))
		tween.tween_interval(0.25)
		tween.tween_callback(load_office)

func load_office():
	player.permanently_disable()
	GlobalEventBus.message.emit("chapter_3_finish", "")
	PlayerLoadPosition.set_player_load_position(Vector2(-8, 0))
	SceneLightingGlobal.fade_in_scene("res://scenes/office/my_office.tscn")
