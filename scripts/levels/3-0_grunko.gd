extends Node2D

@export var theme : AudioStream
@onready var player : PlatformPlayer = $Player
@onready var platform_tile_map : TileMap = $PlatformTileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	BackgroundAudio.play_audio(theme, -20, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
