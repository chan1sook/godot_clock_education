extends Control

class_name ClockToDigitalQuestionNode

signal choose_answer_result(correct: bool, choice: ClockTimeResource)

@onready var _question_clock = $Clock
@onready var _answer_clock = $DigitalClockInput

var _right_answer: ClockTimeResource = ClockTimeResource.new()

func register_question(answer: ClockTimeResource) -> void:
	_right_answer = answer
	_render_question()
	pass

func _render_question() -> void:
	_question_clock.clock_time = _right_answer
	pass


func _on_answer_button_pressed() -> void:
	var answer = _answer_clock.clock_time
	var correct = _question_clock.clock_time.equals_clock(answer)
	choose_answer_result.emit(correct, answer)
	pass
