class_name StaticDialogue
extends CanvasLayer

@onready var header_label : RichTextLabel = $Control/HeaderLabel
@onready var content_label : RichTextLabel = $Control/ContentLabel
@onready var button_1 : Button = $Control/Button1
@onready var button_2 : Button = $Control/Button2
@onready var button_3 : Button = $Control/Button3
@onready var interaction_icon : Sprite2D = $Control/InteractionIcon

var active_dialogue : DialogueNode
var last_interaction_time = Time.get_ticks_msec()
var content_visible_tween : Tween
var is_typing : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	button_1.visible = false
	button_2.visible = false
	button_3.visible = false
	button_1.button_down.connect(handle_choice.bind(0))
	button_2.button_down.connect(handle_choice.bind(1))
	button_3.button_down.connect(handle_choice.bind(2))
	
	var interaction_icon_tween = interaction_icon.create_tween()
	interaction_icon_tween.tween_callback(func(): interaction_icon.frame = 0)
	interaction_icon_tween.tween_interval(1)
	interaction_icon_tween.tween_callback(func(): interaction_icon.frame = 1)
	interaction_icon_tween.set_loops()
	
func handle_choice(choice: int):
	last_interaction_time = Time.get_ticks_msec()
	var dialogue = AllDialogue.get_dialogue(active_dialogue.choices[choice].next_id)
	render_dialogue(dialogue)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not active_dialogue:
		if visible:
			hide_dialogue()
		return

	# Double interactions are happening. Fix later?
	# Or just keep this hack so more than one interaction can't happen quickly
	var has_interacted = false
	if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("ui_accept"):
		if Time.get_ticks_msec() - last_interaction_time >= 100:
			has_interacted = true
	
	# Choice dialogue types get advanced via button press instead
	if active_dialogue.type == "Basic" or active_dialogue.type == "ReceiveItem":
		if has_interacted:
			if is_typing:
				is_typing = false
				content_visible_tween.kill()
				content_label.text = active_dialogue.content
				content_label.visible_ratio = 1.0
			else:
				var next_id = active_dialogue.next_id
				var dialogue = AllDialogue.get_dialogue(next_id)
				if not dialogue:
					GlobalEventBus.message.emit(next_id, "StaticDialogue")
				render_dialogue(dialogue)

func render_dialogue(dialogue : DialogueNode):
	active_dialogue = dialogue
	if not active_dialogue:
		return
		
	if active_dialogue.type == "ReceiveItem":
		GlobalEventBus.receive_item.emit(active_dialogue.item_name)
	else:
		GlobalEventBus.message.emit(active_dialogue.id, "StaticDialogue")

	if active_dialogue.type == "Basic" or active_dialogue.type == "ReceiveItem":
		header_label.text = active_dialogue.header

		content_visible_tween = content_label.create_tween()
		content_visible_tween.tween_callback(func(): is_typing = true)
		content_visible_tween.tween_property(content_label, "visible_ratio", 0, 0)
		content_visible_tween.tween_callback(func(): content_label.text = active_dialogue.content)
		content_visible_tween.tween_property(content_label, "visible_ratio", 1, 0.5)
		content_visible_tween.tween_callback(func(): is_typing = false)
		
		button_1.visible = false
		button_2.visible = false
		button_3.visible = false
	elif active_dialogue.type == "Choice":
		header_label.text = active_dialogue.header
		content_label.text = ""
		var choices = active_dialogue.choices
		if len(choices) > 0:
			button_1.text = choices[0].content
			button_1.visible = true
			button_1.grab_focus()
		if len(choices) > 1:
			button_2.text = choices[1].content
			button_2.visible = true
		if len(choices) > 2:
			button_3.text = choices[2].content
			button_3.visible = true
			
func show_dialogue_node(node : DialogueNode):
	visible = true
	render_dialogue(node)
	last_interaction_time = Time.get_ticks_msec()
	GlobalEventBus.dialogue_activated.emit()

func show_dialogue_scene(id : String):
	var dialogue = AllDialogue.get_dialogue(id)
	show_dialogue_node(dialogue)

func hide_dialogue():
	active_dialogue = null
	visible = false
	GlobalEventBus.dialogue_deactivated.emit()
