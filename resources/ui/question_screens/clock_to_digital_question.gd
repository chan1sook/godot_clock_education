extends Control

class_name ClockToDigitalQuestionNode

signal choose_answer_result(correct: bool, choice: ClockTimeResource)

@export var question_clock: ClockNode
@export var answer_clock: DigitalClockInputNode

var _right_answer: ClockTimeResource = ClockTimeResource.new()

func register_question(answer: ClockTimeResource) -> void:
	_right_answer = answer
	_render_question()

func _render_question() -> void:
	question_clock.clock_time = _right_answer


func _on_answer_button_pressed() -> void:
	var answer = answer_clock.clock_time
	var correct = question_clock.clock_time.equals_clock(answer)
	choose_answer_result.emit(correct, answer)
