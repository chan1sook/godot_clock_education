extends Control

@export var volume_control: VolumeControl
@export var clock_voice_playback: ClockVoicePlayback

@export var time_label: Label
@export var read_clock_container: Control

var clock_time: ClockTimeResource

func _ready() -> void:
	volume_control.volume_percent = Global.global_volume_percent
	
	clock_time = Global.read_clock_time.clone()
	
	time_label.text = str(clock_time)
	var exist_text_list: Array[String] = []
	
	for node in _get_read_clock_nodes():
		node.target_time = clock_time
		var text = node.clock_time_to_text.to_text(clock_time)
		if exist_text_list.has(text):
			node.visible = false
		else:
			node.visible = true
			exist_text_list.push_back(text)

func _process(delta: float) -> void:
	clock_voice_playback.volume_percent = remap(volume_control.volume_percent, 0, 100, 0, 150)

func _on_back_button_pressed() -> void:
	Global.on_change_scene.emit("clock_playground")

func _get_read_clock_nodes() -> Array[ReadClockNode]:
	var result: Array[ReadClockNode] = []
	for node in read_clock_container.get_children():
		if node and node is ReadClockNode:
			result.push_back(node)
	return result
	
func _on_read_clock_node_read_button_pressed(target_node: ReadClockNode) -> void:
	for node in _get_read_clock_nodes():
		node.playing = node == target_node

func _on_clock_voice_playback_finished() -> void:
	for node in _get_read_clock_nodes():
		node.playing = false


func _on_read_clock_volume_control_volume_changed(value: float) -> void:
	Global.global_volume_percent = value
