class_name LabelGenerator
extends Label

@export var x_offset : int = 48
@export var y_offset : int = 0
@export var label_size : float = 16.0
	
func _ready():
	size = Vector2(label_size, label_size)

func generate(max_propagation : int):
	size = Vector2(label_size, label_size)
	for i in range(max_propagation):
		var label = self.duplicate() as LabelGenerator
		label.position = position + Vector2(x_offset * (i + 1), y_offset * (i + 1))
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.text = get_next_text(text, i + 1)
		label.size.y = self.size.y
		get_parent().add_child.call_deferred(label)

func get_next_text(t : String, offset : int):
	if t.is_valid_int():
		return String.num_int64(t.to_int() + offset)
	else:
		var pos = t.unicode_at(0) + offset
		# 'Z' is 90
		if pos > 90:
			var carry = -1
			while pos > 90:
				pos -= 26
				carry += 1
			# 'A' is 65
			return String.chr(65 + carry) + String.chr(pos)
		return String.chr(pos)
