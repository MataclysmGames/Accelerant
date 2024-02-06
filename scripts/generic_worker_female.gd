class_name GenericWorkerFemale
extends Node2D

const frames_until_flip = 20

var tween : Tween
var flip_sprite_periodically = false
var flip_index = 0

@onready var animated_sprite_2d = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	tween = create_tween()
	tween.tween_interval(randf_range(1, 5))
	tween.tween_callback(func(): flip_sprite_periodically = true)
	tween.tween_interval(randf_range(0.25, 1))
	tween.tween_callback(func(): flip_sprite_periodically = false)
	tween.set_loops()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flip_sprite_periodically and should_flip():
		animated_sprite_2d.flip_h = not animated_sprite_2d.flip_h
		flip_index = 0
	flip_index += 1

func should_flip() -> bool:
	return flip_index > frames_until_flip
