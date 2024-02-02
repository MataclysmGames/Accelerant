class_name PlatformCheckpoint
extends Area2D

func _on_body_entered(body : Node2D):
	if body is PlatformPlayer:
		(body as PlatformPlayer).set_reload_position(body.position)
