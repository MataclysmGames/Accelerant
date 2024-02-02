class_name OfficePlayer
extends CharacterBody2D

const SPEED = 65.0

@export var camera_limit_left : int = 0
@export var camera_limit_top : int = 0
@export var camera_limit_right : int = 640
@export var camera_limit_bottom : int = 320
@export var zoom_delta : float = 0.5
@export var min_zoom : float = 1
@export var max_zoom : float = 2

@onready var camera : Camera2D = $Camera2D
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_icon : InteractionIcon = $InteractionIcon
@onready var static_dialogue : StaticDialogue = $StaticDialogue

var can_handle_user_input = true
var is_perma_disabled = false
var direction : Vector2

func _ready():
	var load_position = PlayerLoadPosition.consume_player_load_position()
	if load_position:
		position = load_position
	sprite.animation = PlayerLoadPosition.player_load_animation

	camera.limit_left = camera_limit_left
	camera.limit_top = camera_limit_top
	camera.limit_right = camera_limit_right
	camera.limit_bottom = camera_limit_bottom
	
	GlobalEventBus.dialogue_activated.connect(disable_input)
	GlobalEventBus.dialogue_deactivated.connect(enable_input)
	
func handle_reset():
	if Input.is_action_just_pressed("reset"):
		SceneLightingGlobal.reload_scene(0.5)

func handle_zoom():
	if Input.is_action_just_pressed("zoom_in") and camera.zoom.x + zoom_delta <= max_zoom:
		camera.create_tween().tween_property(camera, "zoom", Vector2(camera.zoom.x + zoom_delta, camera.zoom.x + zoom_delta), 0.25)
	elif Input.is_action_just_pressed("zoom_out") and camera.zoom.x - zoom_delta >= min_zoom:
		camera.create_tween().tween_property(camera, "zoom", Vector2(camera.zoom.x - zoom_delta, camera.zoom.x - zoom_delta), 0.25)
		
func _process(_delta):
	if not is_perma_disabled and can_handle_user_input:
		handle_reset()
		handle_zoom()

func _physics_process(_delta):
	if not is_perma_disabled and can_handle_user_input:
		direction = Input.get_vector("left", "right", "up", "down")
	update_sprite(direction)
	velocity = direction * SPEED
	move_and_slide()
		
func update_sprite(direction : Vector2):
	if direction.x > 0 and abs(direction.x) > abs(direction.y):
		sprite.animation = "walk_side"
		sprite.flip_h = false
	elif direction.x < 0 and abs(direction.x) > abs(direction.y):
		sprite.animation = "walk_side"
		sprite.flip_h = true
	elif direction.y > 0:
		sprite.animation = "walk_down"
		sprite.flip_h = false
	elif direction.y < 0:
		sprite.animation = "walk_up"
		sprite.flip_h = false
	else:
		# Pick idle animation based on previous walk animation
		if sprite.animation == "walk_side":
			sprite.animation = "idle_side"
		elif sprite.animation == "walk_down":
			sprite.animation = "idle_down"
		elif sprite.animation == "walk_up":
			sprite.animation = "idle_up"

func disable_input():
	can_handle_user_input = false
	interaction_icon.visible = false
	direction = Vector2(0, 0)

func permanently_disable():
	can_handle_user_input = false
	is_perma_disabled = true
	interaction_icon.visible = false
	direction = Vector2(0, 0)
	interaction_count = 0
	
func enable_input():
	can_handle_user_input = true
	interaction_icon.visible = interaction_count > 0
	direction = Vector2(0, 0)
	
func can_interact():
	return can_handle_user_input and not is_perma_disabled
	
var interaction_count = 0
func interact_with(_obj : Node2D, valid : bool):
	interaction_count += 1 if valid else -1
	interaction_icon.visible = interaction_count > 0
	
func show_dialogue(header : String, content : String):
	static_dialogue.show_dialogue(header, content)
	
func show_dialogue_scene(id : String):
	static_dialogue.show_dialogue_scene(id)

func show_dialogue_node(node : DialogueNode):
	static_dialogue.show_dialogue_node(node)
