extends Control

class_name DigitalToClockQuestionNode

signal choose_answer_result(correct: bool, choice: ClockTimeResource)

@onready var _question_time_label = $QuestionTimeLabel
@onready var _answer_clock = $Clock

var _right_answer: ClockTimeResource = ClockTimeResource.new()

func register_question(answer: ClockTimeResource) -> void:
	_right_answer = answer
	_render_question()
	pass

func _render_question() -> void:
	_question_time_label.text = str(_right_answer)
	_answer_clock.interactable = true
	pass


func _on_answer_button_pressed() -> void:
	var correct = _answer_clock.clock_time.equals_clock(_right_answer)
	choose_answer_result.emit(correct, _answer_clock.clock_time)
	pass
