# auto load
extends Node

signal on_change_scene(next_scene: String)

### Global constant

const VERSION_SEQ = 9
var VERSION_STR = ProjectSettings.get_setting("application/config/version", "0.2.1")
const UNLIMITED_TIME_FLAG = true
const SUPPORT_LANGUAGES = ["th", "en"]
const SETTING_PATH = "user://setting.ini"

### private value
var _setting_config = ConfigFile.new()
var _volume_percent: float = 100
var _app_lang: String = SUPPORT_LANGUAGES[0]

### Global variables
var read_clock_time: ClockTimeResource = ClockTimeResource.new(8, 0)
var test_score = 10
var test_max_score = 10
var test_questions : Array[QuestionScheme] = []
var question_name: String = ""
var question_description: String = ""

var global_volume_percent: float:
	get:
		return _volume_percent
	set(v):
		_volume_percent = v
		save_config()

var app_lang: String:
	get:
		return _app_lang
	set(v):
		_app_lang = v
		TranslationServer.set_locale(v)
		save_config()
		
func _load_global_config():
	var err = _setting_config.load(SETTING_PATH)

	if err != OK:
		return

	_volume_percent = float(_setting_config.get_value("Sound", "Volume", 100.0))
	_app_lang = _setting_config.get_value("Language", "Language", SUPPORT_LANGUAGES[0])

func save_config():
	_setting_config.set_value("Sound", "Volume", _volume_percent)
	_setting_config.set_value("Language", "Language", _app_lang)
	_setting_config.save(SETTING_PATH)
	
func _ready() -> void:
	_load_global_config()
	
	# apply language
	if not OS.is_debug_build():
		TranslationServer.set_locale(_app_lang)
	
	print_debug(TranslationServer.get_locale())
