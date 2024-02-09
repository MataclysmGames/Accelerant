extends Node

const save_resource_name : String = "user://save.tres"

var save_resource : GameStateResource

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEventBus.receive_item.connect(receive_item_callback)
	GlobalEventBus.message.connect(message_callback)
	save_resource = ResourceLoader.load(save_resource_name) as GameStateResource
	if not save_resource:
		save_resource = GameStateResource.new()

func save_to_disk():
	ResourceSaver.save(save_resource, save_resource_name)

func purge_save_data():
	save_resource = GameStateResource.new()
	save_to_disk()

func receive_item_callback(item_name : String):
	print("Received %s" % item_name)
	add_item(item_name)
	
func message_callback(message : String, sender : String):
	print("[%s] %s --- %s" % [sender, Time.get_datetime_string_from_system(), message])
	if message == "death":
		save_resource.num_deaths += 1
		save_to_disk()
	else:
		add_action(message)

func has_save_data() -> bool:
	return save_resource and (save_resource.actions_done or save_resource.items or save_resource.start_time)

func has_item(item_name : String):
	return save_resource.items.has(item_name)

func add_item(item_name : String):
	save_resource.items.append(item_name)
	save_to_disk()
	
func has_done_action(action : String):
	return save_resource.actions_done.has(action)
	
func add_action(action : String):
	if not has_done_action(action):
		save_resource.actions_done[action] = true
		save_to_disk()

func has_global_volume_set() -> bool:
	return save_resource.global_volume != -1.0
	
func set_global_volume(value : float):
	save_resource.global_volume = value
	save_to_disk()

func get_global_volume() -> float:
	return save_resource.global_volume

func set_start_time():
	if not save_resource.start_time:
		save_resource.start_time = get_system_msec()
		save_to_disk()
	
func set_end_time():
	if not save_resource.end_time:
		save_resource.end_time = get_system_msec()
		save_to_disk()

func get_system_msec():
	var unix_time: float = Time.get_unix_time_from_system()
	var unix_time_ms: int = unix_time * 1000.0
	return unix_time_ms
	
func get_death_count() -> int:
	return save_resource.num_deaths
