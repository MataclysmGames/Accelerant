class_name InteractionIcon
extends Sprite2D

@export var rotation_amount : int = 15
@export var rotation_duration : float = 1.0

var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	tween = create_tween()
	tween.tween_property(self, "rotation_degrees", rotation_amount, rotation_duration)
	tween.tween_interval(0.5)
	tween.tween_property(self, "rotation_degrees", 0, rotation_duration)
	tween.tween_interval(0.5)
	tween.set_loops()
