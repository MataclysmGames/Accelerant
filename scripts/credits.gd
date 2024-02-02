extends Node2D

@onready var title_label : Label = $CanvasLayer/Control/VBoxContainer/TitleLabel
@onready var info_label : Label = $CanvasLayer/Control/VBoxContainer/InfoLabel
@onready var time_played_label = $CanvasLayer/Control/VBoxContainer/TimePlayedLabel
@onready var num_deaths_label = $CanvasLayer/Control/VBoxContainer/NumDeathsLabel

var tween : Tween
var do_random_text : bool = false

var initial_title_label_text : String
var initial_info_label_text : String

var able_to_proceed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	title_label.modulate = Color(0, 0, 0, 0)
	info_label.modulate = Color(0, 0, 0, 0)
	time_played_label.modulate = Color(0, 0, 0, 0)
	num_deaths_label.modulate = Color(0, 0, 0, 0)
	tween = create_tween()
	tween.tween_property(title_label, "modulate", Color(1, 1, 1, 1), 1.0)
	tween.tween_interval(1)
	tween.tween_property(info_label, "modulate", Color(1, 1, 1, 1), 1.0)
	tween.tween_interval(1)
	tween.tween_callback(func(): do_random_text = true)
	tween.tween_interval(1)
	tween.tween_callback(func(): do_random_text = false)
	tween.tween_callback(func(): info_label.text = "Thank you for playing!")
	tween.tween_callback(set_time_played)
	tween.tween_property(time_played_label, "modulate", Color(1, 1, 1, 1), 1.0)
	tween.tween_callback(set_num_deaths)
	tween.tween_property(num_deaths_label, "modulate", Color(1, 1, 1, 1), 1.0)
	tween.tween_callback(func(): able_to_proceed = true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
var count = 0
func _process(_delta):
	count += 1
	if do_random_text and count % 10 == 0:
		count = 0
		info_label.text = random_text(19)
	
	if able_to_proceed and (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("escape")):
		SceneLightingGlobal.fade_in_scene("res://scenes/main_menu.tscn")

var alphabet : String = "abcdefghijklmnopqrstuvwxyz_ !ABCDEFGHIJKLMNOPQRSTUVWXYZ"
func random_text(count : int = 8):
	var random_str = ""
	for i in range(count):
		var ch = alphabet[randi_range(0, len(alphabet) - 1)]
		random_str = random_str + ch
	return random_str

func set_time_played():
	if not GameState.save_resource.start_time:
		return
	GameState.set_end_time()
	var duration : int = GameState.save_resource.end_time - GameState.save_resource.start_time
	var d_ms = duration % 1000
	var d_sec = (duration / 1000) % 60
	var d_min = (duration / (1000 * 60)) % 60
	var d_hr = (duration / (1000 * 60 * 60)) % 24
	var d_day = (duration / (1000 * 60 * 60 * 24))
	time_played_label.text = "Time: %02d:%02d:%02d:%02d.%03d" % [d_day, d_hr, d_min, d_sec, d_ms]

func set_num_deaths():
	num_deaths_label.text = "Deaths: " + str(GameState.get_death_count())
