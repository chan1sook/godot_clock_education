extends Control

signal choose_answer_result(correct: bool, choice: ClockTimeResource)

@onready var _question_time_label = $QuestionTimeLabel
@onready var _clock_a = $HBoxContainer/VBoxContainerA/Control/Clock
@onready var _clock_b = $HBoxContainer/VBoxContainerB/Control/Clock
@onready var _clock_c = $HBoxContainer/VBoxContainerC/Control/Clock
@onready var _clock_d = $HBoxContainer/VBoxContainerD/Control/Clock

var _choices: Array[ClockTimeResource] = []
var _answer_at: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func register_question(choice: Array[ClockTimeResource], answer_at: int) -> void:
	_choices = choice
	_answer_at = answer_at
	_render_question()
	pass

func _render_question() -> void:
	_question_time_label.text = str(_choices[_answer_at])
	_clock_a.clock_time =  _choices[0]
	_clock_b.clock_time =  _choices[1]
	_clock_c.clock_time =  _choices[2]
	_clock_d.clock_time =  _choices[3]
	pass
	
func _format_clock_str(time: ClockTimeResource) -> String:
	return str(time)
	

func _on_answer_a_button_pressed() -> void:
	choose_answer_result.emit(_answer_at == 0, _choices[0])
	pass


func _on_answer_b_button_pressed() -> void:
	choose_answer_result.emit(_answer_at == 1, _choices[1])
	pass


func _on_answer_c_button_pressed() -> void:
	choose_answer_result.emit(_answer_at == 2, _choices[2])
	pass


func _on_answer_d_button_pressed() -> void:
	choose_answer_result.emit(_answer_at == 3, _choices[3])
	pass
