extends Node2D

const default_audio_volume : float = 0.15
@export var theme : AudioStream

@onready var play_button : Button = $CanvasLayer/Control/VBoxContainer/ButtonsContainer/PlayButton
@onready var exit_button : Button = $CanvasLayer/Control/VBoxContainer/ButtonsContainer/ExitButton
@onready var volume_slider : HSlider = $CanvasLayer/Control/VolumeContainer/VolumeSlider
@onready var volume_label : Label = $CanvasLayer/Control/VolumeContainer/VolumeLabel
@onready var delete_save_button : Button = $CanvasLayer/Control/VolumeContainer/DeleteSaveDataButton

@onready var controller_container = $CanvasLayer/Control/ControllerContainer
@onready var keyboard_container = $CanvasLayer/Control/KeyboardContainer
@onready var show_control_label = $CanvasLayer/Control/ShowControlLabel

var controls_hidden : bool = true
var initial_delete_button_text : String
var delete_save_timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	AllDialogue.load_dialogue_dict()
	BackgroundAudio.play_audio(theme, -20, 1)
	
	play_button.pressed.connect(play_button_pressed)
	exit_button.pressed.connect(exit_button_pressed)
	delete_save_button.pressed.connect(delete_save_button_pressed)
	volume_slider.value_changed.connect(volume_slider_changed)
	delete_save_button.visible = GameState.has_save_data()
	initial_delete_button_text = delete_save_button.text
	play_button.grab_focus()
	
	set_volume_level()
	
	controller_container.modulate = Color(0, 0, 0, 0)
	keyboard_container.modulate = Color(0, 0, 0, 0)
	
func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		controls_hidden = not controls_hidden
		if controls_hidden:
			controller_container.modulate = Color(0, 0, 0, 0)
			keyboard_container.modulate = Color(0, 0, 0, 0)
			show_control_label.text = "Press 'Q' to show controls"
		else:
			controller_container.modulate = Color(1, 1, 1, 1)
			keyboard_container.modulate = Color(1, 1, 1, 1)
			show_control_label.text = "Press 'Q' to hide controls"

func play_button_pressed():
	GameState.set_start_time()
	SceneLightingGlobal.fade_in_scene("res://scenes/office/office_reception.tscn", 0, 2)

func exit_button_pressed():
	get_tree().quit()

func delete_save_button_pressed():
	if not delete_save_timer:
		delete_save_button.text = "Deleting..."
		GameState.purge_save_data()
		delete_save_timer = Timer.new()
		delete_save_timer.one_shot = true
		delete_save_timer.autostart = true
		delete_save_timer.wait_time = 1.0
		delete_save_timer.timeout.connect(delete_save_button_pressed_callback)
		add_child(delete_save_timer)
		
func delete_save_button_pressed_callback():
	play_button.grab_focus()
	delete_save_button.visible = false
	delete_save_button.text = initial_delete_button_text
	delete_save_timer = null

func volume_slider_changed(value : float):
	volume_label.text = "Volume: " + "%3d" % (value * 100)
	GameState.set_global_volume(value)
	var master_bus_index = AudioServer.get_bus_index("Master")
	if master_bus_index != -1:
		AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))
	else:
		push_error("Unable to find Master audio bus")

func get_master_bus_volume():
	var master_bus_index = AudioServer.get_bus_index("Master")
	if master_bus_index != -1:
		var db_volume = AudioServer.get_bus_volume_db(master_bus_index)
		return db_to_linear(db_volume)
	else:
		push_error("Unable to find Master audio bus")
		return 0

func set_volume_level():
	if not GameState.has_global_volume_set():
		GameState.set_global_volume(default_audio_volume)
	volume_slider.value = GameState.get_global_volume()
