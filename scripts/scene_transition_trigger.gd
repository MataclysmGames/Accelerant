class_name SceneTransitionTrigger
extends Area2D

@export var scene_to_load : String
@export var player_load_position : Vector2
@export var player_load_animation : String = "idle_up"
@export var required_item_or_action : String

var triggered : bool = false

func _on_body_entered(body : Node2D):
	if not triggered and (body is PlatformPlayer or body is OfficePlayer):
		if not required_item_or_action or GameState.has_item(required_item_or_action) or GameState.has_done_action(required_item_or_action):
			triggered = true
			PlayerLoadPosition.set_player_load_animation(player_load_animation)
			if player_load_position:
				PlayerLoadPosition.set_player_load_position(player_load_position)
			
			body.disable_input()
			SceneLightingGlobal.fade_in_scene(scene_to_load)
		elif required_item_or_action:
			body.show_dialogue_scene("no_%s" % required_item_or_action)

func _on_body_exited(body):
	if triggered and (body is PlatformPlayer or body is OfficePlayer):
		triggered = false
