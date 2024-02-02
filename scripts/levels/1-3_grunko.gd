extends Node2D

@export var theme : AudioStream
@onready var jan_expenses_amount_label = $JanExpensesAmountLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	BackgroundAudio.play_audio(theme, -20, 0.4)
	GlobalEventBus.message.connect(handle_message)

func handle_message(message : String, _sender : String):
	if message == "chapter_1_finish":
		jan_expenses_amount_label.text = "816,772.03"
