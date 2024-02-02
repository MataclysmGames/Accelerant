class_name AccelGrid

var empty_value : String = ""

var width : int
var height : int

var cells : Array[String]

func _init(width : int, height : int):
	self.width = width
	self.height = height

	cells.resize(width * height)
	cells.fill(empty_value)

func get_cell(x : int, y : int) -> String:
	var cell_index = (y * width) + x
	return cells[cell_index]

func set_cell(x : int, y : int, val : String):
	var cell_index = (y * width) + x
	cells[cell_index] = val

func inc_cell(x : int, y : int, amount : int = 1) -> String:
	var cell_index = (y * width) + x
	cells[cell_index] = String.num_int64(cells[cell_index].to_int() + amount)
	return cells[cell_index]
