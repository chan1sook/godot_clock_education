extends Control

class_name ClockToDigitalChoiceQuestionNode
signal choose_answer_result(correct: bool, choice: ClockTimeResource)

@onready var _question_clock = $Clock
@onready var _answer_btn_a = $AnswerButtonVContainer/ButtonA
@onready var _answer_btn_b = $AnswerButtonVContainer/ButtonB
@onready var _answer_btn_c = $AnswerButtonVContainer/ButtonC
@onready var _answer_btn_d = $AnswerButtonVContainer/ButtonD

var _choices: Array[ClockTimeResource] = []
var _answer_at: int = -1

func register_question(choice: Array[ClockTimeResource], answer_at: int) -> void:
	_choices = choice
	_answer_at = answer_at
	_render_question()
	pass

func _render_question() -> void:
	_question_clock.clock_time = _choices[_answer_at]
	_answer_btn_a.text = "ก. " + _format_clock_str( _choices[0])
	_answer_btn_b.text = "ข. " + _format_clock_str( _choices[1])
	_answer_btn_c.text = "ค. " + _format_clock_str( _choices[2])
	_answer_btn_d.text = "ง. " + _format_clock_str( _choices[3])
	pass
	
func _format_clock_str(time: ClockTimeResource) -> String:
	return str(time)
	

func _on_button_a_pressed() -> void:
	choose_answer_result.emit(_answer_at == 0, _choices[0])
	pass


func _on_button_b_pressed() -> void:
	choose_answer_result.emit(_answer_at == 1, _choices[1])
	pass


func _on_button_c_pressed() -> void:
	choose_answer_result.emit(_answer_at == 2, _choices[2])
	pass


func _on_button_d_pressed() -> void:
	choose_answer_result.emit(_answer_at == 3, _choices[3])
	pass
