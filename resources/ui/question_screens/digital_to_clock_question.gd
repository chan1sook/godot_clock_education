extends Control

class_name DigitalToClockQuestionNode

signal choose_answer_result(correct: bool, choice: ClockTimeResource)

@export var question_time_label: Label
@export var answer_clock: ClockNode

var _right_answer: ClockTimeResource = ClockTimeResource.new()

func register_question(answer: ClockTimeResource) -> void:
	_right_answer = answer
	_render_question()
	pass

func _render_question() -> void:
	question_time_label.text = str(_right_answer)
	answer_clock.interactable = true
	pass


func _on_answer_button_pressed() -> void:
	var correct = answer_clock.clock_time.equals_clock(_right_answer)
	choose_answer_result.emit(correct, answer_clock.clock_time)
	pass
