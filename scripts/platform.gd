class_name Platform
extends AnimatableBody2D

@export var relative_destination : Vector2
@export var move_duration : float = 2.0
@export var wait_duration : float = 1.0
@export var enabled : bool = true

var initial_position : Vector2
var movement_tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = position
	if relative_destination:
		create_movement_tween(enabled)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func enable():
	enabled = true
	movement_tween.play()
	
func create_movement_tween(playing : bool):
	movement_tween = create_tween()
	if not playing:
		movement_tween.pause()
	movement_tween.tween_property(self, "position", initial_position + relative_destination, move_duration)
	movement_tween.tween_interval(wait_duration)
	movement_tween.tween_property(self, "position", initial_position, move_duration)
	movement_tween.tween_interval(wait_duration)
	movement_tween.set_loops()
