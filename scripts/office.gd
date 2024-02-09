extends Node2D

@export var theme : AudioStream

@onready var office_player : OfficePlayer = $OfficePlayer

@onready var npc_daniel = $NPC_Daniel
@onready var npc_omar = $NPC_Omar
@onready var npc_brenda = $NPC_Brenda

@onready var cutscene_trigger = $CutsceneTrigger

func _ready():
	BackgroundAudio.play_audio(theme, -20, 1)
	cutscene_trigger.trigger.connect(standup_cutscene)
	GlobalEventBus.message.connect(handle_message)
	if not GameState.has_done_action("standup_done"):
		move_characters_to_standup()
	elif not GameState.has_done_action("standup_done_ack"):
		office_player.show_dialogue_scene("standup_done_ack")
	
	if GameState.has_done_action("chapter_4_finish"):
		if GameState.has_done_action("brenda_fire_employee_omar"):
			remove_child(npc_omar)
		if GameState.has_done_action("brenda_fire_employee_daniel"):
			remove_child(npc_daniel)

func move_characters_to_standup():
	npc_daniel.position = Vector2(372, 165)
	npc_omar.position = Vector2(405, 172)
	npc_brenda.position = Vector2(393, 221)

func standup_cutscene(cutscene_name : String):
	match cutscene_name:
		"standup":
			office_player.permanently_disable()
			var tween = create_tween()
			tween.tween_property(office_player.camera, "zoom", Vector2(1.5, 1.5), 1)
			tween.tween_callback(func(): office_player.show_dialogue_scene("standup"))
		_:
			push_error("Invalid cutscene match %s" % cutscene_name)

func handle_message(message : String, _sender : String):
	if message == "standup_done":
		office_player.permanently_disable()
		SceneLightingGlobal.fade_in_scene("res://scenes/office/office.tscn", 3.0, 1.0)
	elif message == "game_end":
		office_player.permanently_disable()
		SceneLightingGlobal.fade_in_scene("res://scenes/credits.tscn", 3.0, 1.0)
