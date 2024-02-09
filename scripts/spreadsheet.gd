class_name Spreadsheet
extends Node2D

@export var num_columns : int = 7
@export var num_rows : int = 5

@onready var functionLabel : Label = $FunctionLabel
@onready var cellLabel : Label = $CellPositionLabel
@onready var player : PlatformPlayer = $"../Player"
@onready var columnGen : LabelGenerator = $ColumnLabelGenerator
@onready var rowGen : LabelGenerator = $RowLabelGenerator

func _ready():
	start_function_label_flash()
	columnGen.generate(num_columns - 1)
	rowGen.generate(num_rows - 1)

func start_function_label_flash():
	var tween = functionLabel.create_tween()
	tween.tween_callback(func(): functionLabel.text = " fx=|")
	tween.tween_interval(1)
	tween.tween_callback(func(): functionLabel.text = " fx=")
	tween.tween_interval(1)
	tween.set_loops()
	
func _process(_delta):
	if player and cellLabel:
		var player_position = player.get_cell_position()
		var cell_name = player.get_cell_name(player_position)
		cellLabel.text = cell_name
