extends Node

class_name ClockVoicePlayback

@export var voices: Dictionary = {}
@export var voice_word_offset: Dictionary = {}
@export var slient_time: float = 0.4

@onready var audio_player_1 = $AudioStreamPlayer
@onready var audio_player_2 = $AudioStreamPlayer2
@onready var silent_timer = $SilentTimer

var voice_queue: Array[String] = []
var use_alt: bool = false

func _process(delta: float) -> void:
	if voice_queue.size() > 0 and silent_timer.is_stopped():
		var token = voice_queue.pop_front()
		if token == " ": # silent voice
			silent_timer.start(slient_time)
		else:
			var current_voice : AudioStream = voices.get(token)
			if current_voice:
				var offset : float = 0
				if voice_queue.size() > 0 and voice_queue[0] != " ":
					offset = voice_word_offset.get(token, offset)
				var time_left = max(current_voice.get_length() + offset, 0)
				print("voice_info => ", {
					"token": token,
					"voice_len": current_voice.get_length(),
					"offset": offset,
					"time_left": time_left,
				})
				
				var audio_player = _get_audio_player()
				audio_player.stream = current_voice
				audio_player.play()
				use_alt = not use_alt
				silent_timer.start(time_left)

func _get_audio_player() -> AudioStreamPlayer:
	if use_alt:
		return audio_player_2
	return audio_player_1

func play(tokens: Array[String]):
	stop()
	voice_queue = tokens.slice(0)

func stop():
	voice_queue = []
	audio_player_1.stop()
	audio_player_2.stop()
	silent_timer.stop()
	
