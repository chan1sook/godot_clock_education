extends RefCounted

class_name TTSConfig

var voice: String
var rate: String
var volume: String
var pitch: String

# Validates the TTSConfig object after initialization.
func _init(_voice: String, _rate: String, _volume: String, _pitch: String) -> void:
	# Possible values for voice are:
	# - Microsoft Server Speech Text to Speech Voice (cy-GB, NiaNeural)
	# - cy-GB-NiaNeural
	# - fil-PH-AngeloNeural
	
	# Always send the first variant as that is what Microsoft Edge does.
	var regex = RegEx.new()
	regex.compile(r"^([a-z]{2,})-([A-Z]{2,})-(.+Neural)$")
	var _match = regex.search(_voice)
	if _match != null:
		var lang = _match.get_string(1)
		var region = _match.get_string(2)
		var name = _match.get_string(3)
		var name_dash_i = name.find("-")
		if name_dash_i != -1:
			region = region + "-" + name.substr(0, name_dash_i)
			name = name.substr(name_dash_i)
		_voice = "Microsoft Server Speech Text to Speech Voice (" + lang + "-" + region + ", " + name + ")"

		# Validate the rate, volume, and pitch parameters.
		voice = _validate_string_param(_voice, r"^Microsoft Server Speech Text to Speech Voice \(.+,.+\)$",)
		rate = _validate_string_param(_rate, r"^[+-]\d+%$")
		volume = _validate_string_param(_volume, r"^[+-]\d+%$")
		pitch = _validate_string_param(_pitch, r"^[+-]\d+Hz$")

func _validate_string_param(param_value: String, pattern: String) -> String:
	# Validates the given string parameter based on type and pattern.
	var regex = RegEx.new()
	regex.compile(pattern)
	assert(regex.search(param_value) != null, "Invalid value:" + param_value)
	return param_value

func _to_string() -> String:
	return voice + "(" + rate + "," + volume + "," + pitch + ")"

static func default() -> TTSConfig:
	return TTSConfig.new("en-US-EmmaMultilingualNeural", "+0%", "+0%", "+0Hz")
