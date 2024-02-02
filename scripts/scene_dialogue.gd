class_name SceneDialogue
extends Node2D

@onready var control : Control = $Control
@onready var header_label : RichTextLabel = $Control/PanelContainer/VBoxContainer/Header
@onready var content_label : RichTextLabel = $Control/PanelContainer/VBoxContainer/Content

var contentArray : PackedStringArray
var contentArrayIndex : int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	control.visible = false
	
func _process(_delta):
	if contentArrayIndex >= 0 and Input.is_action_just_pressed("interact"):
		contentArrayIndex += 1
		if contentArrayIndex >= len(contentArray):
			hide_dialogue()
		else:
			content_label.text = "[font_size=10]" + contentArray[contentArrayIndex]
	
func show_dialogue(header : String, content : String):
	if contentArrayIndex == -1:
		contentArray = content.split("#")
		contentArrayIndex = 0
		header_label.text = "[font_size=10]" + header
		content_label.text = contentArray[contentArrayIndex]
		control.visible = true

func hide_dialogue():
	contentArrayIndex = -1
	control.visible = false
