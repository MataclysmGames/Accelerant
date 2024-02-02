class_name CutsceneTrigger
extends Area2D

signal trigger(name : StringName)

@export var cutscene_name : StringName
@export var one_shot : bool = true

var has_triggered_cutscene : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	has_triggered_cutscene = GameState.has_done_action(cutscene_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_body_entered(body):
	if body is OfficePlayer or body is PlatformPlayer:
		if one_shot and has_triggered_cutscene:
			return
		trigger.emit(cutscene_name)
		has_triggered_cutscene = true
		GameState.add_action(cutscene_name)

func _on_body_exited(_body):
	pass # Replace with function body.
