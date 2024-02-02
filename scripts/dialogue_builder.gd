class_name DialogueBuilder

var base_id : String
var dialogue_index : int
var next_id : String
var current_header : String
var current_content : String
var final_id : String

var dialogue_nodes : Array[DialogueNode]

func _init(id : String):
	base_id = id
	dialogue_index = 0
	dialogue_nodes = []
	
func with_header(header : String) -> DialogueBuilder:
	current_header = header
	return self
	
func with_content(content : String) -> DialogueBuilder:
	var current_id = base_id
	if dialogue_index != 0:
		current_id = "%s_%d" % [base_id, dialogue_index]
	var next_id = "%s_%d" % [base_id, dialogue_index + 1]
	dialogue_index += 1

	var new_node = DialogueNode.Basic(current_id, current_header, content, next_id)
	dialogue_nodes.append(new_node)
	return self

func with_content_list(content_list : Array[String]) -> DialogueBuilder:
	for content in content_list:
		self.with_content(content)
	return self

func with_choices(header : String, choices : Array[Choice]) -> DialogueBuilder:
	var current_id = "%s_%d" % [base_id, dialogue_index]
	var new_node = DialogueNode.Choice(current_id, header, choices)
	dialogue_nodes.append(new_node)
	dialogue_index += 1
	return self
	
func with_next_id(id : String) -> DialogueBuilder:
	dialogue_nodes[-1].next_id = id
	return self
	
func with_final_id(id : String) -> DialogueBuilder:
	if len(dialogue_nodes) > 1:
		dialogue_nodes[-2].next_id = id
	dialogue_nodes[-1].id = id
	return self
	
func with_receive_item(item_name : String) -> DialogueBuilder:
	var current_id = base_id
	if dialogue_index != 0:
		current_id = "%s_%d" % [base_id, dialogue_index]
	var next_id = "%s_%d" % [base_id, dialogue_index + 1]
	dialogue_index += 1
	
	var new_node = DialogueNode.ReceiveItem(current_id, item_name, next_id)
	dialogue_nodes.append(new_node)
	return self

func build() -> Array[DialogueNode]:
	return dialogue_nodes
