class_name Clippy
extends CharacterBody2D

var speed = 85

@onready var player : PlatformPlayer = $"../Player"

var can_move : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player and can_move:
		var pos_diff : Vector2 = player.position - position
		if pos_diff.length() < 25:
			player.kill_reload_position(Vector2(250, 100))
			velocity = Vector2.ZERO
		else:
			velocity = pos_diff.normalized() * speed
		
		if position.x > 2500:
			var clippy_tween = create_tween()
			clippy_tween.tween_property(self, "modulate", Color(1, 0, 0, 0), 2)
			clippy_tween.tween_callback(func(): position = Vector2.ZERO)
			velocity = Vector2.ZERO
			can_move = false
		move_and_slide()
