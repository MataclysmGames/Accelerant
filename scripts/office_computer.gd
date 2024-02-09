extends Node2D

@onready var terminal = $BootCanvasLayer/Control/Terminal

@onready var header_label : Label = $BootCanvasLayer/Control/Terminal/Header/Label
@onready var content_text : TextEdit = $BootCanvasLayer/Control/Terminal/Text

var boot_tween : Tween
var content : String

func _ready():
	BackgroundAudio.stop_audio()
	# Please for the love of God just remove the scrollbars
	content_text.get_v_scroll_bar().modulate = Color(0, 0, 0, 0)
	content_text.get_h_scroll_bar().modulate = Color(0, 0, 0, 0)
	content_text.remove_child(content_text.get_h_scroll_bar())
	content_text.get_h_scroll_bar().position = Vector2(-1000, -1000)
	terminal.visible = false
	
	boot_tween = create_tween()
	boot_tween.tween_callback(func(): terminal.visible = true)
	boot_tween.tween_interval(0.25)
	
	var file_contents = FileAccess.get_file_as_string("res://assets/boot.txt")
	if not file_contents:
		boot_tween.tween_callback(func(): content = "Unable to load boot file...")
	else:
		var lines = file_contents.split("\n")
		for line in lines:
			boot_tween.tween_callback(func(): content += "\n" + line)
			boot_tween.tween_interval(0.005)
	
	boot_tween.tween_interval(1.5)
	boot_tween.tween_callback(func(): content += "Connecting to database...")
	boot_tween.tween_interval(1)
	boot_tween.tween_callback(func(): content += "DONE")
	boot_tween.tween_interval(0.5)
	boot_tween.tween_callback(func(): content += "\nReticulating splines...")
	boot_tween.tween_interval(1)
	boot_tween.tween_callback(func(): content += "DONE")
	boot_tween.tween_interval(0.5)
	boot_tween.tween_callback(func(): content += "\nExtra buffer to prevent race conditions...")
	boot_tween.tween_interval(1)
	boot_tween.tween_callback(func(): content += "DONE")
	boot_tween.tween_interval(0.5)
	boot_tween.tween_callback(func(): content += "\nEntering database...")
	
	boot_tween.tween_callback(func(): SceneLightingGlobal.fade_in_scene("res://scenes/platform/title_screen.tscn"))

func _process(_delta):
	content_text.text = content
	content_text.scroll_vertical = 1000
