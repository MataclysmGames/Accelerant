extends Node2D

@export var theme : AudioStream
@onready var office_player : OfficePlayer = $OfficePlayer
@onready var interaction_zone_safe = $InteractionZoneSafe
@onready var my_office_safe = $MyOfficeSafe

var reenable_timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	BackgroundAudio.play_audio(theme, -20, 1)
	var can_interact_with_safe : bool = GameState.has_done_action("suspicious_reports_need_safe") and not GameState.has_done_action("safe_unlock")
	if not can_interact_with_safe:
		remove_child(interaction_zone_safe)
	GlobalEventBus.message.connect(handle_message)
	
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
		
func reenable_safe_unlock():
	add_child(interaction_zone_safe)
