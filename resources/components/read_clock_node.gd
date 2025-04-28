extends HBoxContainer

class_name ReadClockNode

signal read_button_pressed(node: ReadClockNode)

@export var voice_playback: ClockVoicePlayback
@export var clock_time_to_text: ClockTimeToReadText
@export var target_time: ClockTimeResource
@export var flag_texture: Texture2D
@export var playing: bool

@export_group("Nodes")
@export var text_label: Label
@export var read_btn: Button
@export var flag_node: TextureRect

func _process(delta: float) -> void:
	flag_node.texture = flag_texture
	text_label.text = clock_time_to_text.to_text(target_time)
	
	var btn_theme = ""
	var btn_text = tr("ReadClockScene.ReadButton")
	if playing:
		btn_theme = "PurpleButton"
		btn_text = tr("ReadClockScene.ReadingButton")
	read_btn.theme_type_variation = btn_theme
	read_btn.text = btn_text

func _on_read_button_pressed() -> void:
	if voice_playback:
		voice_playback.play(clock_time_to_text.to_voice_tokens(target_time))
		read_button_pressed.emit(self)
