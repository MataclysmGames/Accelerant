class_name DialogueEntity extends Object

var dialogue_builders : Array[DialogueBuilder]
var dialogue_progression : Array[Array]
var default_dialogue : String = ""

var dialogue_dict = {}

func _init():
	load_dialogue_dict()

func load_dialogue_dict():
	if not dialogue_dict:
		for builder in dialogue_builders:
			var dialogue_list : Array[DialogueNode] = builder.build()
			for dialogue in dialogue_list:
				dialogue_dict[dialogue.id] = dialogue

func get_active_dialogue() -> DialogueNode:
	var dialogue = get_dialogue(default_dialogue)
	for prog in dialogue_progression:
		if prog[0] and GameState.has_done_action(prog[0]):
			dialogue = get_dialogue(prog[1])
	return dialogue

func get_dialogue(id : String) -> DialogueNode:
	return dialogue_dict.get(id)
