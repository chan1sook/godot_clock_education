# auto load
extends Node

### Global constant

const VERSION_SEQ = 7
var VERSION_STR = ProjectSettings.get_setting("application/config/version", "0.1.2")
const UNLIMITED_TIME_FLAG = true

### Global variables

var test_score = 10
var test_max_score = 10
var test_questions : Array[QuestionScheme] = []
var question_name: String = ""
var question_description: String = ""

### Scene Signal
signal on_change_scene(next_scene: String)
