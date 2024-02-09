extends Node2D

@export var theme : AudioStream
@onready var office_player : OfficePlayer = $OfficePlayer
@onready var interaction_zone_safe = $InteractionZoneSafe
@onready var interaction_zone_secret_door = $InteractionZoneSecretDoor
@onready var my_office_safe = $MyOfficeSafe
@onready var secret_door = $SecretDoor
@onready var cutscene_trigger_lights = $CutsceneTriggerLights
@onready var secret_room_lights = $SecretRoomLights
@onready var interaction_zone_push_button = $InteractionZonePushButton

var reenable_timer : Timer

func _ready():
	secret_room_lights.energy = 0
	BackgroundAudio.play_audio(theme, -20, 1)
	if not GameState.has_done_action("suspicious_reports_need_safe") or GameState.has_done_action("safe_unlock"):
		remove_child(interaction_zone_safe)
	if GameState.has_done_action("reset_button_pressed"):
		secret_door.move()
		remove_child(interaction_zone_secret_door)
	GlobalEventBus.message.connect(handle_message)
	cutscene_trigger_lights.trigger.connect(turn_on_lights)
	
	reenable_timer = Timer.new()
	reenable_timer.one_shot = true
	reenable_timer.timeout.connect(reenable_safe_unlock)
	add_child(reenable_timer)

func handle_message(message : String, _sender : String):
	if message == "my_office_safe_enter_code":
		office_player.disable_input()
		my_office_safe.start_unlock(office_player)
		remove_child(interaction_zone_safe)
	elif message == "safe_exit" or message == "safe_failed":
		office_player.enable_input()
		my_office_safe.end_unlock()
		reenable_timer.start(0.35)
	elif message == "safe_unlock":
		my_office_safe.end_unlock()
		office_player.show_dialogue_scene("my_office_safe_unlock")
	elif message == "my_office_secret_door_open":
		office_player.enable_input()
		remove_child(interaction_zone_secret_door)
		secret_door.move()
	elif message == "reset_button_pressed":
		pass

func reenable_safe_unlock():
	add_child(interaction_zone_safe)

func turn_on_lights(_cutscene_name : String):
	secret_room_lights.create_tween().tween_property(secret_room_lights, "energy", 1.0, 3)
