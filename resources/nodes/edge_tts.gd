extends Node

class_name EdgeTTS

# tryhard implement edge tts to godot
var BASE_URL = "speech.platform.bing.com/consumer/speech/synthesize/readaloud"
var TRUSTED_CLIENT_TOKEN = "6A5AA1D4EAFF4E9FB37E23D68491D6F4"
var WSS_URL = "wss://" + BASE_URL + "/edge/v1?TrustedClientToken=" + TRUSTED_CLIENT_TOKEN
var VOICE_LIST = "https://" + BASE_URL + "/voices/list?trustedclienttoken=" + TRUSTED_CLIENT_TOKEN

var CHROMIUM_FULL_VERSION = "130.0.2849.68"
var CHROMIUM_MAJOR_VERSION = CHROMIUM_FULL_VERSION.split(".", true, 1)[0]
var SEC_MS_GEC_VERSION = "1-" + CHROMIUM_FULL_VERSION
var BASE_HEADERS = {
	"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" +
		" (KHTML, like Gecko) Chrome/" + CHROMIUM_MAJOR_VERSION + ".0.0.0 Safari/537.36" +
		" Edg/" + CHROMIUM_MAJOR_VERSION + ".0.0.0",
	"Accept-Encoding": "gzip, deflate, br",
	"Accept-Language": "en-US,en;q=0.9",
}
var WSS_HEADERS = {
	"Pragma": "no-cache",
	"Cache-Control": "no-cache",
	"Origin": "chrome-extension://jdiccldimpdaibmpdkjnbmckianbfold",
}
var VOICE_HEADERS = {
	"Authority": "speech.platform.bing.com",
	"Sec-CH-UA": '" Not;A Brand";v="99", "Microsoft Edge";v="' + CHROMIUM_MAJOR_VERSION + '",' +
		' "Chromium";v="' + CHROMIUM_MAJOR_VERSION + '"',
	"Sec-CH-UA-Mobile": "?0",
	"Accept": "*/*",
	"Sec-Fetch-Site": "none",
	"Sec-Fetch-Mode": "cors",
	"Sec-Fetch-Dest": "empty",
}

# Store current state of TTS.
  #"offset_compensation": 0,
			#"last_duration_offset": 0,
var _stream_was_called = false

func _init() -> void:
	WSS_HEADERS.merge(BASE_HEADERS)
	VOICE_HEADERS.merge(BASE_HEADERS)

# Splits a string into a list of strings of a given byte length
# while attempting to keep words together. This function assumes
# text will be inside of an XML tag.
func _split_text_by_byte_length(text: String, byte_length: int) -> Array[String]:
	
	#if isinstance(text, str):
		#text = text.encode("utf-8")
	#if not isinstance(text, bytes):
		#raise TypeError("text must be str or bytes")

	assert(byte_length > 0, "byte_length must be greater than 0")
	var texts: Array[String] = []
	while text.length() > byte_length:
		# Find the last space in the string
		var split_at = text.rfind(" ", byte_length)
		
		# If no space found, split_at is byte_length
		if split_at == -1:
			split_at = byte_length
			
		# Verify all & are terminated with a;
		while text.substr(0, split_at):
			var ampersand_index = text.rfind("&", split_at)
			if text.substr(ampersand_index, split_at).find(";") != -1:
				break
			split_at = ampersand_index - 1
			assert(split_at >= 0, "Maximum byte length is too small or invalid text")
			if split_at == 0:
				break
		
		# Append the string to the list
		var new_text = text.substr(0, split_at).strip_edges()
		if new_text:
			texts.append(new_text)
		if split_at == 0:
			split_at = 1
			text = text.substr(split_at)
		
	var new_text = text.strip_edges()
	if new_text:
		texts.append(new_text)
	
	return texts

# Returns the headers and data to be used in the request.
func _ssml_headers_plus_data(request_id: String, timestamp: String, ssml: String) -> String:
	return (
		"X-RequestId:" + request_id + "\r\n" +
		"Content-Type:application/ssml+xml\r\n" +
		"X-Timestamp:" + timestamp + "Z\r\n" + # This is not a mistake, Microsoft Edge bug.
		"Path:ssml\r\n\r\n" +
		"{ssml}"
	)
	
# Returns a UUID without dashes.
func _connect_id() -> String:
	return ""
	# return uuid.v4().replace("-", "")

# Return Javascript-style date string.
func _date_to_string() -> String:
	
	var ds = Time.get_datetime_dict_from_system()
	var hour = ds["hour"]
	var hour_str = str(hour)
	if hour < 10:
		hour_str = "0" + hour_str
	var minute = ds["minute"]
	var minute_str = str(minute)
	if minute < 10:
		minute_str = "0" + minute_str
	var sec = ds["second"]
	var second_str = str(sec)
	if sec < 10:
		second_str = "0" + second_str
	
	var weekday_str_list = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
	var weekdaty_str = weekday_str_list[ds["weekday"]]
	
	var month_str_list = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	var month_str = month_str_list[ds["month"] - 1]
	# Tue Aug 19 1975 
	var date_str = "%a " + month_str + " " + ds["day"] + " " +  ds["year"]
	var time_str = hour_str + ":" + minute_str + ":" + second_str
	return date_str + " " + time_str + " GMT+0000 (Coordinated Universal Time)"

# Creates a SSML string from the given parameters.
func _mkssml(tc: TTSConfig, escaped_text: String) -> String:
	return (
		"<speak version='1.0' xmlns='http://www.w3.org/2001/10/synthesis' xml:lang='en-US'>" +
		"<voice name='" + tc.voice + "'>" +
		"<prosody pitch='" + tc.pitch + "' rate='" + tc.rate + "' volume='" + tc.volume + "'>" +
		escaped_text +
		"</prosody>" +
		"</voice>" +
		"</speak>"
	)
	

func _calc_max_mesg_size(tts_config: TTSConfig) -> int:
	# Calculates the maximum message size for the given voice, rate, and volume.
	var websocket_max_size: int = 2**16
	var overhead_per_message: int = (
		len(
			_ssml_headers_plus_data(
				_connect_id(),
				_date_to_string(),
				_mkssml(tts_config, ""),
			)
		)
		+ 50  # margin of error
	)
	return websocket_max_size - overhead_per_message

# Streams audio and metadata from the service.
func steam(text: String, tss_config = TTSConfig.default()) -> void:
	#var texts = _split_text_by_byte_length(
		#escape(remove_incompatible_characters(text)),
		#_calc_max_mesg_size(self.tts_config),
	#)
		
	# Check if stream was called before.
	# assert(not _stream_was_called, "stream can only be called once.")
	_stream_was_called = true
	
	#for _partial_text in self.texts:
		## Stream the audio and metadata from the service.
		#for self.state["partial_text"] in self.texts:
			#try:
				#async for message in self.__stream():
					#yield message
			#except aiohttp.ClientResponseError as e:
				#if e.status != 403:
					#raise
#
				#DRM.handle_client_response_error(e)
				#async for message in self.__stream():
					#yield message
