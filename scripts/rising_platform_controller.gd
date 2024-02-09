extends Area2D

@export var platform : RisingPlatform
@export var multi_platform : Array[RisingPlatform]
@export var one_shot : bool = false

var player_in_area : bool = false
var player_node : PlatformPlayer = null
var has_triggered : bool = false

func _process(_delta):
	if one_shot and has_triggered:
		return
	var is_interact_pressed = Input.is_action_just_pressed("interact")
	if player_in_area and is_interact_pressed:
		if platform:
			has_triggered = true
			platform.move()
		elif multi_platform:
			has_triggered = true
			for p in multi_platform:
				p.move()

func _on_body_entered(body : Node2D):
	if body is PlatformPlayer:
		player_in_area = true
		player_node = body as PlatformPlayer
		player_node.interact_with(self, true)

func _on_body_exited(body : Node2D):
	if body is PlatformPlayer:
		player_in_area = false
		player_node.interact_with(self, false)
