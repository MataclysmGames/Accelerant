class_name InteractionZone
extends Area2D

@export var interaction_name : StringName
@export var dialogue_scene : bool = false

var player_in_area : bool = false
var player_node : Node2D = null

func _on_body_entered(body : Node2D):
	if body.has_method("interact_with"):
		player_in_area = true
		player_node = body
		body.interact_with(self, true)

func _on_body_exited(body : Node2D):
	if body.has_method("interact_with"):
		player_in_area = false
		player_node = null
		body.interact_with(self, false)

func _process(_delta):
	var is_interact_pressed = Input.is_action_just_pressed("interact")
	if player_in_area and is_interact_pressed and player_node.can_interact():
		if dialogue_scene:
			player_node.show_dialogue_scene(interaction_name)
			return

		match interaction_name:
			"my_office_computer":
				player_node.disable_input()
				if not GameState.has_done_action("chapter_0_finish"):
					SceneLightingGlobal.fade_in_scene("res://scenes/office/office_computer.tscn")
				elif not GameState.has_done_action("reset_button_pressed"):
					if GameState.has_done_action("chapter_1_start") and not GameState.has_done_action("chapter_1_finish"):
						SceneLightingGlobal.fade_in_scene("res://scenes/platform/title_screen.tscn")
					elif GameState.has_done_action("chapter_2_start") and not GameState.has_done_action("chapter_2_finish"):
						SceneLightingGlobal.fade_in_scene("res://scenes/platform/title_screen.tscn")
					elif GameState.has_done_action("chapter_3_start"):
						player_node.show_dialogue_scene("need_to_press_reset_button")
					else:
						player_node.show_dialogue_scene("no_need_for_computer")
				else:
					if GameState.has_done_action("chapter_3_start") and not GameState.has_done_action("chapter_3_finish"):
						SceneLightingGlobal.fade_in_scene("res://scenes/platform/title_screen_after_button.tscn")
					elif GameState.has_done_action("chapter_4_start") and not GameState.has_done_action("chapter_4_finish"):
						SceneLightingGlobal.fade_in_scene("res://scenes/platform/title_screen_after_button.tscn")
					else:
						player_node.show_dialogue_scene("no_need_for_computer")
			"my_office_secret_door":
				if GameState.has_item("Office Hidden Door Passcode"):
					player_node.show_dialogue_scene("my_office_secret_door_with_passcode")
				else:
					player_node.show_dialogue_scene("my_office_secret_door_without_passcode")
			"chapter_0_finish", "chapter_1_finish", "chapter_2_finish", "chapter_3_finish", "chapter_4_finish":
				player_node.disable_input()
				GlobalEventBus.message.emit(interaction_name, "InteractionZone")
				PlayerLoadPosition.set_player_load_position(Vector2(-8, 0))
				SceneLightingGlobal.fade_in_scene("res://scenes/office/my_office.tscn")
			"npc_tom":
				player_node.show_dialogue_node(DialogueTom.singleton().get_active_dialogue())
			"npc_molly":
				player_node.show_dialogue_node(DialogueMolly.singleton().get_active_dialogue())
			"npc_brenda":
				player_node.show_dialogue_node(DialogueBrenda.singleton().get_active_dialogue())
			"npc_omar":
				player_node.show_dialogue_node(DialogueOmar.singleton().get_active_dialogue())
			"npc_daniel":
				player_node.show_dialogue_node(DialogueDaniel.singleton().get_active_dialogue())
			"defragment":
				GlobalEventBus.message.emit("defragment", "InteractionZone")
			"push_reset_button":
				if GameState.has_done_action("reset_button_pressed"):
					player_node.show_dialogue_scene("reset_button_already_pressed")
				else:
					player_node.show_dialogue_scene("reset_button")
			_:
				var message = "Invalid interaction name [" + interaction_name + "]"
				print_rich("[color=red]" + message + "[/color]")
	elif player_in_area and player_node.can_handle_user_input:
		pass
