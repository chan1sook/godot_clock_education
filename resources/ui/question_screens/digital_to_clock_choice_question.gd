extends Control

class_name DigitalToClockChoiceQuestionNode

signal choose_answer_result(correct: bool, choice: ClockTimeResource)

@export var question_time_label: Label
@export var clocks: Array[ClockNode]

var _choices: Array[ClockTimeResource] = []
var _answer_at: int = -1

func register_question(choice: Array[ClockTimeResource], answer_at: int) -> void:
	_choices = choice
	_answer_at = answer_at
	_render_question()

func _render_question() -> void:
	question_time_label.text = str(_choices[_answer_at])
	for i in range(clocks.size()):
		clocks[i].clock_time = _choices[i]
	
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
