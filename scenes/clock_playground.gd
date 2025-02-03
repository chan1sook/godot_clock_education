extends Control

var _is_syncing_time: bool = false

@export var start_time: ClockTimeResource = ClockTimeResource.new(8, 0)
@export var voices_map : Dictionary = {}

@onready var clock: ClockNode = $Clock
@onready var digital_clock_input: DigitalClockInputNode = $DigitalClockInput
@onready var sync_btn: Button = $SyncTimeButton
@onready var read_text_control = $ReadTextControl
@onready var read_text_label = $ReadTextControl/ReadTextLabel
@onready var audio_player = $AudioStreamPlayer
@onready var silent_timer = $AudioStreamPlayer/SilentTimer

var read_time: ClockTimeResource
var formal_clock_time_to_text = ClockTimeToText.new()
var informal_clock_time_to_text = ClockTimeToTextInformal1.new()
var is_informal: bool = false
var voice_queue: Array[String] = []

func _ready() -> void:
	read_text_control.visible = false
	_apply_time_to_clocks(start_time)

func _process(delta: float) -> void:
	sync_btn.button_pressed = _is_syncing_time
	if _is_syncing_time:
		_apply_time_to_clocks(_get_sync_time())
	if voice_queue.size() > 0 and not audio_player.playing and silent_timer.is_stopped():
		var token = voice_queue.pop_front()
		if token == " ": # silent voice
			silent_timer.start(0.5)
		else:
			var current_voice : AudioStream = voices_map.get(token)
			if current_voice:
				audio_player.stream = current_voice
				audio_player.play()

func _get_sync_time() -> ClockTimeResource:
	var time_result = Time.get_time_dict_from_system()
	return ClockTimeResource.new(time_result.hour, time_result.minute)
	
func _apply_time_to_clocks(clock_time: ClockTimeResource) -> void:
	clock.clock_time = clock_time
	digital_clock_input.clock_time = clock_time
	_reset_voices()
	read_text_control.visible = false

func _reset_voices():
	voice_queue = []
	audio_player.stop()
	silent_timer.stop()
	
func _on_clock_time_changed(time: ClockTimeResource) -> void:
	_is_syncing_time = false
	_reset_voices()
	read_text_control.visible = false
	digital_clock_input.clock_time = time

func _on_digital_clock_input_time_changed(time: ClockTimeResource) -> void:
	_is_syncing_time = false
	_reset_voices()
	read_text_control.visible = false
	start_time = time
	clock.clock_time = start_time

func _on_sync_time_button_pressed() -> void:
	if not _is_syncing_time:
		_apply_time_to_clocks(_get_sync_time())
	else:
		_is_syncing_time = false

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_read_time_formal_button_pressed() -> void:
	read_time = clock.clock_time
	is_informal = false
	read_text_label.text = formal_clock_time_to_text.to_text(read_time)
	read_text_control.visible = true

func _on_read_time_informal_button_pressed() -> void:
	read_time = clock.clock_time
	is_informal = true
	read_text_label.text = informal_clock_time_to_text.to_text(read_time)
	read_text_control.visible = true

func _on_speak_clock_text_button_pressed() -> void:
	_reset_voices()
	if is_informal:
		voice_queue = informal_clock_time_to_text.to_text_tokens(read_time)
	else:
		voice_queue = formal_clock_time_to_text.to_text_tokens(read_time)
