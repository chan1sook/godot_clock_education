extends RefCounted

class_name ReadTextData

var text: String
var voice_text: String
var silent: bool
var silent_duration: float

func _init(text: String, voice_text: String = "", silent: bool = false, silent_duration: float = 0.3) -> void:
	self.text = text
	self.silent = silent
	self.silent_duration = silent_duration
	self.voice_text = voice_text

func get_voice_text() -> String:
	if voice_text != "":
		return voice_text
	return text
