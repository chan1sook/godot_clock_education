extends Node

class_name ClockVoicePlayback

signal finished()

@export_range(0, 100, 1.0, "or_greater") var volume_percent: float = 150

@export_group("Playback")
@export var audio_players: Array[AudioStreamPlayer]
@export var silent_timer: Timer
var channel: int = 0
var token_queue: Array[ReadTextData] = []
var _playing: bool = false

func _process(delta: float) -> void:
	for player in audio_players:
		player.volume_linear = volume_percent / 100.0
	
	# check finished
	if token_queue.size() == 0 and silent_timer.is_stopped() and _playing:
		_playing = false
		finished.emit()
	
	if token_queue.size() > 0 and silent_timer.is_stopped():
		_playing = true
		_queue_next_voice()
		
func _queue_next_voice():
	var token: ReadTextData = token_queue.pop_front()
	
	if token.silent: # silent voice
		silent_timer.start(token.silent_duration)
	else:
		var voice_text = token.get_voice_text()
		var current_voice : AudioStream
		var offset_start: float = 0
		var offset_end: float = 0
		
		var resource_path = "res://resources/resources/voice_info_data/%s.tres" % [voice_text]
		var resource_voice = ResourceLoader.load(resource_path) as VoiceInfoData
		if resource_voice:
			current_voice = resource_voice.voice
			offset_start = resource_voice.offset_start
			offset_end = resource_voice.offset_end
		
		#print_debug("voice_info => ", {
			#"voice_text": voice_text,
			#"resource_path": resource_path,
			#"has_voice": not not resource_voice,
			#"offset_start": offset_start,
			#"offset_end": offset_end,
		#})
		
		if current_voice:
			var voice_duration = max(current_voice.get_length() + offset_end, 0)
			
			#print_debug("voice_info => ", {
				##"voice_len": current_voice.get_length(),
				##"voice_duration": voice_duration,
				#"voice_text": voice_text,
			#})
			
			var audio_player = _get_audio_player()
			audio_player.stream = current_voice
			audio_player.play(offset_start)
			channel = (channel + 1) % audio_players.size()
			silent_timer.start(voice_duration)

func _get_audio_player() -> AudioStreamPlayer:
	return audio_players[channel]

func play(tokens: Array[ReadTextData]):
	stop()
	token_queue = tokens.slice(0)

func stop():
	token_queue = []
	silent_timer.stop()
	channel = 0
	for player in audio_players:
		player.stop()
	
