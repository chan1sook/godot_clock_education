extends Node

@export var scenes: Dictionary #String: PackedScene
@export var start_scene_name: StringName
var _current_scene: Node

func _ready() -> void:
	Global.on_change_scene.connect(_on_change_scene)
	
	_on_change_scene(start_scene_name)

func _push_new_scene(next_scene: PackedScene):
	var _next_scene = next_scene.instantiate()
	add_child(_next_scene)
	if _current_scene:
		_current_scene.queue_free()
	_current_scene = _next_scene
	
func _on_change_scene(next_scene: String):
	if not scenes.has(next_scene):
		return
	_push_new_scene(scenes[next_scene])
