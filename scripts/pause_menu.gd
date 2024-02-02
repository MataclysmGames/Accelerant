extends Node2D

@onready var canvas_layer : CanvasLayer = $CanvasLayer
@onready var resume_button : Button = $CanvasLayer/Control/VBoxContainer/ButtonsContainer/PlayButton
@onready var exit_button : Button = $CanvasLayer/Control/VBoxContainer/ButtonsContainer/ExitButton
@onready var volume_slider : HSlider = $CanvasLayer/Control/VolumeContainer/VolumeSlider
@onready var volume_label : Label = $CanvasLayer/Control/VolumeContainer/VolumeLabel

var last_pause_action : int = Time.get_ticks_msec()

# Called when the node enters the scene tree for the first time.
func _ready():
	canvas_layer.visible = false
	resume_button.pressed.connect(unpause)
	exit_button.pressed.connect(exit_button_pressed)
	volume_slider.value_changed.connect(volume_slider_changed)

func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		toggle_pause()
		
func toggle_pause():
	if should_toggle_pause():
		if get_node_or_null("/root/MainMenu") or get_node_or_null("/root/OfficeComputer")  or get_node_or_null("/root/Credits"):
			return
		#if not OfficePlayer.can_handle_user_input:
		#	return
		var tree = get_tree()
		last_pause_action = Time.get_ticks_msec()
		tree.paused = not tree.paused
		canvas_layer.visible = not canvas_layer.visible
		
		if canvas_layer.visible:
			resume_button.grab_focus()
			volume_slider.value = get_master_bus_volume()

func pause():
	if should_toggle_pause():
		last_pause_action = Time.get_ticks_msec()
		get_tree().paused = true
		canvas_layer.visible = true

func unpause():
	if should_toggle_pause():
		last_pause_action = Time.get_ticks_msec()
		get_tree().paused = false
		canvas_layer.visible = false
	
func should_toggle_pause():
	var now = Time.get_ticks_msec()
	return now - last_pause_action > 100

func exit_button_pressed():
	get_tree().quit()

func volume_slider_changed(value : float):
	volume_label.text = "Volume: " + "%3d" % (value * 100)
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
