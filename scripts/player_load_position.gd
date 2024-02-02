extends Node

var player_load_position : Vector2 = Vector2(0, 0)
var player_load_animation : String = "idle_up"

func set_player_load_position(position : Vector2):
	player_load_position = position
	
func set_player_load_animation(load_animation : String):
	player_load_animation = load_animation

func consume_player_load_position():
	var position = player_load_position
	player_load_position = Vector2(0, 0)
	return position
