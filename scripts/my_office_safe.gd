extends CanvasLayer

@export var acceptable_answers : Array[String] = ["1111"]

@onready var button_1 = $Control/GridContainer/Button1
@onready var button_2 = $Control/GridContainer/Button2
@onready var button_3 = $Control/GridContainer/Button3
@onready var button_4 = $Control/GridContainer/Button4
@onready var button_5 = $Control/GridContainer/Button5
@onready var button_6 = $Control/GridContainer/Button6
@onready var button_7 = $Control/GridContainer/Button7
@onready var button_8 = $Control/GridContainer/Button8
@onready var button_9 = $Control/GridContainer/Button9
@onready var button_back = $Control/GridContainer/Button10
@onready var button_0 = $Control/GridContainer/Button11
@onready var button_exit = $Control/GridContainer/Button12

@onready var value_1 = $Control/EnteredValuesContainer/Value1
@onready var value_2 = $Control/EnteredValuesContainer/Value2
@onready var value_3 = $Control/EnteredValuesContainer/Value3
@onready var value_4 = $Control/EnteredValuesContainer/Value4

var entered_values : String = ""
var office_player : OfficePlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	button_1.button_down.connect(handle_choice.bind("1"))
	button_2.button_down.connect(handle_choice.bind("2"))
	button_3.button_down.connect(handle_choice.bind("3"))
	button_4.button_down.connect(handle_choice.bind("4"))
	button_5.button_down.connect(handle_choice.bind("5"))
	button_6.button_down.connect(handle_choice.bind("6"))
	button_7.button_down.connect(handle_choice.bind("7"))
	button_8.button_down.connect(handle_choice.bind("8"))
	button_9.button_down.connect(handle_choice.bind("9"))
	button_0.button_down.connect(handle_choice.bind("0"))
	button_back.button_down.connect(handle_choice.bind("back"))
	button_exit.button_down.connect(handle_choice.bind("exit"))
	
	button_1.grab_focus()

func handle_choice(choice : String):
	if choice == "back":
		if len(entered_values) > 0:
			entered_values = entered_values.substr(0, len(entered_values) - 1)
	elif choice == "exit":
		GlobalEventBus.message.emit("safe_exit", "MyOfficeSafe")
	else:
		entered_values += choice
		if entered_values in acceptable_answers:
			GlobalEventBus.message.emit("safe_unlock", "MyOfficeSafe")
		elif len(entered_values) == 4:
			GlobalEventBus.message.emit("safe_failed", "MyOfficeSafe")
			entered_values = ""
			
func end_unlock():
	hide()
	self.office_player = null
	
func start_unlock(office_player : OfficePlayer):
	show()
	button_1.grab_focus()
	self.office_player = office_player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var input_len = len(entered_values)
	value_1.text = entered_values[0] if input_len > 0 else ""
	value_2.text = entered_values[1] if input_len > 1 else ""
	value_3.text = entered_values[2] if input_len > 2 else ""
	value_4.text = entered_values[3] if input_len > 3 else ""
	
	if visible and office_player:
		office_player.disable_input()
