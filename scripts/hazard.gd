class_name Hazard
extends Node2D

@onready var sprite : Sprite2D = $Sprite2D

func _ready():
	sprite.flip_h = randf_range(0.0, 1.0) > 0.5

func _on_area_2d_body_entered(body : Node2D):
	if body is PlatformPlayer:
		var player = body as PlatformPlayer
		player.kill(self)
