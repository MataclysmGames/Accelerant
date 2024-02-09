class_name RisingPlatform
extends AnimatableBody2D

@export var max_movement : int = 3
@export var movement_delta : Vector2i = Vector2i(0, -16)
@export var movement_duration : float = 1.0
@export var color : Color = Color.BLACK

@onready var color_rect : ColorRect = $ColorRect

var initial_position : Vector2
var current_movement_index : int = 0
var movement_sign : int = 1
var is_moving = false

func _ready():
	initial_position = position
	color_rect.color = color

func move():
	if not is_moving:
		var tween = create_tween()
		tween.tween_callback(pre_move)
		tween.tween_property(self, "position", Vector2(Vector2i(position) + movement_delta * movement_sign), movement_duration)
		tween.tween_callback(post_move)

func pre_move():
	is_moving = true
	current_movement_index += movement_sign
	if current_movement_index == 0:
		movement_sign = 1
	if current_movement_index == max_movement:
		movement_sign = -1

func post_move():
	is_moving = false
	var pos = Vector2(Vector2i(initial_position) + (current_movement_index * movement_delta))
	self.position = pos
