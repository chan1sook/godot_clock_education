extends Control

class_name TestTimerBar

signal timeout()

@onready var _container = $HBoxContainer
@onready var _progress_bar = $HBoxContainer/ProgressBar
@onready var _label = $HBoxContainer/Label
@onready var _timer = $QuestionTimer
@export var show_time: bool = true
var _max_time_limit : float = -1

func _ready() -> void:
	_set_show_bar_visible()
	pass

func _process(delta: float) -> void:
	_set_show_bar_visible()
	if _max_time_limit >= 0:
		_progress_bar.value = _timer.time_left
		_label.text = _format_time(_timer.time_left)
	else:
		_progress_bar.value = _progress_bar.max_value
		_label.text = ""
	pass

func _on_question_timer_timeout() -> void:
	timeout.emit()

func _format_time(sec: float) -> String:
	var time_left_rouned = floor(_timer.time_left)
	var minute = floor(time_left_rouned / 60)
	var second = int(time_left_rouned) % 60
	
	var second_str = str(second)
	if second < 10:
		second_str = "0" + second_str
	return str(minute) + ":" + second_str

func _set_show_bar_visible():
	_container.visible = show_time and _max_time_limit > 0
	_label.visible = show_time
	
func start_time(time_limit: float):
	_max_time_limit = time_limit
	
	if _max_time_limit <= 0:
		_progress_bar.min_value = 0
		_progress_bar.max_value = 1
		_progress_bar.value = _progress_bar.max_value
	else:
		_timer.wait_time = _max_time_limit
		_progress_bar.min_value = 0
		_progress_bar.max_value = _max_time_limit
		_timer.start()
