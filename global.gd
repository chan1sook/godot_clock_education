# auto load
extends Node

### Global constant

const VERSION_SEQ = 8
var VERSION_STR = ProjectSettings.get_setting("application/config/version", "0.2.0")
const UNLIMITED_TIME_FLAG = true
const SUPPORT_LANGUAGES = ["th", "en"]

### Global variables
var test_score = 10
var test_max_score = 10
var test_questions : Array[QuestionScheme] = []
var question_name: String = ""
var question_description: String = ""

### Scene Signal
signal on_change_scene(next_scene: String)
