class_name DialogueNode

var id : String
var type : String
var header : String
var content : String
var choices : Array[Choice]
var next_id : String
var signal_name : String
var item_name : String

func with_signal(signal_name : String):
	self.signal_name = signal_name
	return self

static func Basic(id : String, header : String, content : String, next_id : String):
	var node = DialogueNode.new()
	node.id = id
	node.type = "Basic"
	node.header = header
	node.content = content
	node.next_id = next_id
	return node
	
static func Choice(id : String, header : String, choices : Array[Choice]):
	var node = DialogueNode.new()
	node.id = id
	node.type = "Choice"
	node.header = header
	node.choices = choices
	return node
	
static func ReceiveItem(id : String, item_name : String, next_id : String):
	var node = DialogueNode.new()
	node.id = id
	node.next_id = next_id
	node.item_name = item_name
	node.type = "ReceiveItem"
	node.content = "Received [color=green]%s[/color]." % item_name
	return node
