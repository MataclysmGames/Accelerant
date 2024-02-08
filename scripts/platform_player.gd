class_name PlatformPlayer
extends CharacterBody2D

const SPEED = 105.0
const JUMP_VELOCITY = -200.0
const MAX_FALL_SPEED = 200
const COYOTE_FRAMES = 5

@export var camera_limit_top : int = 0
@export var camera_limit_left : int = 0
@export var camera_limit_right : int = 400
@export var camera_limit_bottom : int = 1000

@export var zoom_delta : float = 0.5
@export var min_zoom : float = 1
@export var max_zoom : float = 2

@export var reload_scene_on_death : bool = true

@onready var camera : Camera2D = $Camera2D
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_icon : InteractionIcon = $InteractionIcon
@onready var static_dialogue : StaticDialogue = $StaticDialogue
@onready var spreadsheet : Spreadsheet = $"../Spreadsheet"
@onready var camera_target : RemoteTransform2D = $CameraTarget

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Player state
var is_alive : bool = true
var can_handle_user_input : bool = true
var death_position : Vector2
var death_timer_is_created : bool = false
var reload_position : Vector2
var can_zoom : bool = true
var frames_since_grounded = 0
var has_jumped : bool = false
var is_perma_disabled : bool = false

# Camera target
var target_list_size = 60
var target_index = 0
var last_velocity_x_list : Array[float]

func _ready():
	var load_position = PlayerLoadPosition.consume_player_load_position()
	if load_position:
		position = load_position
	reload_position = position
	camera.limit_top = camera_limit_top
	camera.limit_left = camera_limit_left
	camera.limit_right = camera_limit_right
	camera.limit_bottom = camera_limit_bottom
	
	last_velocity_x_list.resize(target_list_size)
	
	GlobalEventBus.dialogue_activated.connect(disable_input)
	GlobalEventBus.dialogue_deactivated.connect(enable_input)
		
func get_cell_position() -> Vector2i:
	var pos = global_position
	var col_index = floor((pos.x - 48) / 48)
	var row_index = floor((pos.y - 48) / 16)
	return Vector2(col_index, row_index)
	
func get_cell_name(pos : Vector2i) -> String:
	var col_name = String.chr("A".unicode_at(0) + pos.x)
	var row_name = String.num(pos.y + 1)
	var cell_name = col_name + row_name
	return cell_name
	
func handle_cell_selection():
	if Input.is_action_just_pressed("interact") and not interaction_icon.visible:
		var pos = ($AnimatedSprite2D as AnimatedSprite2D).global_position
		var col_index = floor((pos.x - 48) / 48)
		var row_index = floor((pos.y - 48) / 16)
		if col_index < 0 or row_index < 0:
			return "OOB"
		var col_name = String.chr("A".unicode_at(0) + col_index)
		var row_name = String.num(row_index + 1)
		var cell_name = col_name + row_name
		#spreadsheet.interact_cell(cell_name, col_index, row_index)
		#disable_input()
		
func handle_mouse_click():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		position = get_global_mouse_position()
	
func handle_reset():
	if not is_perma_disabled and Input.is_action_just_pressed("reset"):
		if reload_scene_on_death:
			get_tree().reload_current_scene()
		else:
			position = reload_position

func handle_zoom():
	if not can_zoom:
		return

	var has_zoomed_in = Input.is_action_just_pressed("zoom_in")
	var has_zoomed_out = Input.is_action_just_pressed("zoom_out")
	if has_zoomed_in or has_zoomed_out:
		can_zoom = false
		var tween = camera.create_tween()
		if has_zoomed_in and camera.zoom.x + zoom_delta <= max_zoom:
			tween.tween_property(camera, "zoom", Vector2(camera.zoom.x + zoom_delta, camera.zoom.x + zoom_delta), 0.25)
		elif has_zoomed_out and camera.zoom.x - zoom_delta >= min_zoom:
			tween.tween_property(camera, "zoom", Vector2(camera.zoom.x - zoom_delta, camera.zoom.x - zoom_delta), 0.25)
		if tween:
			tween.tween_callback(enable_zooming)
	
func enable_zooming():
	can_zoom = true

func handle_vertical_movement(delta):
	if is_perma_disabled:
		# Let the script controlling the player decide what their velocity should be
		return
		
	if is_on_floor():
		has_jumped = false
		frames_since_grounded = 0
	else:
		frames_since_grounded += 1
		# Add the gravity.
		var fall_factor = 0.4 if Input.is_action_pressed("jump") else 0.6
		velocity.y += gravity * fall_factor * delta
		velocity.y = min(velocity.y, MAX_FALL_SPEED)
		
		if velocity.y > 0 and sprite.animation != "fall":
			sprite.animation = "fall"

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or (not has_jumped and frames_since_grounded < COYOTE_FRAMES):
			velocity.y += JUMP_VELOCITY
			has_jumped = true

func handle_horizontal_movement(_delta):
	if is_perma_disabled:
		# Let the script controlling the player decide what their velocity should be
		return
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED / 4)
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED / 2)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 3)
	
	if is_on_floor():
		if velocity.x != 0:
			sprite.animation = "run"
		else:
			sprite.animation = "idle"

	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false

func handle_camera_target():
	# Update list of last n velocity values
	last_velocity_x_list[target_index] = velocity.x
	target_index += 1
	target_index = target_index % target_list_size
	
	# Calculate avg velocity based on last 60 frames
	# Yes I could keep a running total, allowing just one subtraction, one additon, and one division
	# But I really can't be bothered
	var avg_velocity_x = avg(last_velocity_x_list)

	# Determine how much to lead the camera
	var x_lead = avg_velocity_x / 2
	camera_target.position.x = move_toward(camera_target.position.x, x_lead, 0.5)
	
	if is_on_floor():
		var look_up_down_direction = Input.get_axis("up", "down")
		camera_target.position.y = move_toward(camera_target.position.y, look_up_down_direction * 75, 3)
	
func avg(list : Array[float]) -> float:
	var total = 0.0
	for val in list:
		total += val
	return total / len(list)

func handle_death():
	sprite.rotation_degrees = move_toward(sprite.rotation_degrees, -90, 5)
	position.y = move_toward(position.y, death_position.y + 8, 0.5)
	
	if not death_timer_is_created:
		if reload_scene_on_death:
			SceneLightingGlobal.reload_scene(0.5)
		death_timer_is_created = true
		var timer = Timer.new()
		timer.wait_time = 0.5
		timer.one_shot = true
		timer.autostart = true
		timer.connect("timeout", death_timer_callback)
		add_child(timer)
	
func death_timer_callback():
	sprite.rotation_degrees = 0
	is_alive = true
	death_timer_is_created = false
	if not reload_scene_on_death:
		position = reload_position
	
func _process(_delta):
	if not is_alive:
		handle_death()
	elif can_handle_user_input:
		handle_cell_selection()
		handle_reset()
		handle_zoom()
		#handle_mouse_click()

func _physics_process(delta):
	if is_alive and can_handle_user_input:
		handle_horizontal_movement(delta)
		handle_vertical_movement(delta)
		move_and_slide()
		handle_camera_target()

func kill(_killer : Node2D):
	if is_alive:
		velocity.y = 0
		death_position = position
		is_alive = false
		GlobalEventBus.message.emit("death", "PlatformPlayer")
	else:
		print("You are already dead")

func permanently_disable():
	can_handle_user_input = false
	is_perma_disabled = true
	interaction_icon.visible = false
	interaction_count = 0

func permanently_enable():
	can_handle_user_input = true
	is_perma_disabled = false

func disable_input():
	can_handle_user_input = false
	interaction_icon.visible = false
	
func enable_input():
	can_handle_user_input = true
	interaction_icon.visible = interaction_count > 0
	
func can_interact():
	return can_handle_user_input
	
var interaction_count = 0
func interact_with(_obj : Node2D, valid : bool):
	interaction_count += 1 if valid else -1
	interaction_icon.visible = interaction_count > 0

func show_dialogue(header : String, content : String):
	static_dialogue.show_dialogue(header, content)

func set_reload_position(pos : Vector2):
	reload_position = pos
	
func show_dialogue_scene(id : String):
	static_dialogue.show_dialogue_scene(id)

func show_dialogue_node(node : DialogueNode):
	static_dialogue.show_dialogue_node(node)

func kill_reload_position(pos : Vector2):
	PlayerLoadPosition.set_player_load_position(pos)
	reload_position = pos
	reload_scene_on_death = true
	kill(null)
