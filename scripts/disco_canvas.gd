extends CanvasModulate

@export var min_color_value : float = 0.25
@export var max_color_value : float = 0.75
@export var color_duration : int = 15

var frames = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	frames += 1
	if frames >= color_duration:
		frames = 0
		color = Color(randf_range(min_color_value, max_color_value), randf_range(min_color_value, max_color_value), randf_range(min_color_value, max_color_value), 1.0)
