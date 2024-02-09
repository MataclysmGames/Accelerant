extends Node2D

@export var theme : AudioStream

@onready var player : PlatformPlayer = $Player
@onready var chapter_0_label : Label = $Chapter0Label
@onready var chapter_1_label : Label = $Chapter1Label
@onready var chapter_2_label : Label = $Chapter2Label
@onready var chapter_3_label : Label = $Chapter3Label
@onready var chapter_4_label : Label = $Chapter4Label

@onready var platform : Platform = $Platform

var chapter_0_done : bool
var chapter_1_done : bool
var chapter_2_done : bool
var chapter_3_done : bool
var chapter_4_done : bool

var alphabet : String = "abcdefghijklmnopqrstuvwxyz_ !ABCDEFGHIJKLMNOPQRSTUVWXYZ"

func _ready():
	BackgroundAudio.play_audio(theme, -20, 1)
	chapter_0_done = GameState.has_done_action("chapter_0_finish")
	chapter_1_done = GameState.has_done_action("chapter_1_finish")
	chapter_2_done = GameState.has_done_action("chapter_2_finish")
	chapter_3_done = GameState.has_done_action("chapter_3_finish")
	chapter_4_done = GameState.has_done_action("chapter_4_finish")
	show_chapter_completion_dialogue()
	
	if platform and chapter_0_done:
		platform.enable()

func show_chapter_completion_dialogue():
	if chapter_0_done and not GameState.has_done_action("chapter_0_finish_ack"):
		player.show_dialogue_scene("chapter_0_finish_ack")
	if chapter_1_done and not GameState.has_done_action("chapter_1_finish_ack"):
		player.show_dialogue_scene("chapter_1_finish_ack")
	if chapter_2_done and not GameState.has_done_action("chapter_2_finish_ack"):
		player.show_dialogue_scene("chapter_2_finish_ack")
	if chapter_3_done and not GameState.has_done_action("chapter_3_finish_ack"):
		player.show_dialogue_scene("chapter_3_finish_ack")
	if chapter_4_done and not GameState.has_done_action("chapter_4_finish_ack"):
		player.show_dialogue_scene("chapter_4_finish_ack")

var count = 0
func _process(_delta):
	count += 1
	if count % 15 == 0:
		count = 0
		if not chapter_0_done:
			chapter_1_label.text = random_text()
		if not chapter_1_done:
			chapter_2_label.text = random_text()
		if not chapter_2_done:
			chapter_3_label.text = random_text()
		if not chapter_3_done:
			chapter_4_label.text = random_text()
			
func random_text(count : int = 8):
	var random_str = ""
	for i in range(count):
		var ch = alphabet[randi_range(0, len(alphabet) - 1)]
		random_str = random_str + ch
	return random_str
