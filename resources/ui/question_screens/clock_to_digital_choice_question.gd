extends Control

class_name ClockToDigitalChoiceQuestionNode
signal choose_answer_result(correct: bool, choice: ClockTimeResource)

@export var question_clock: ClockNode
@export var answer_buttons: Array[Button]

var _choices: Array[ClockTimeResource] = []
var _answer_at: int = -1

func register_question(choice: Array[ClockTimeResource], answer_at: int) -> void:
	_choices = choice
	_answer_at = answer_at
	_render_question()

func _render_question() -> void:
	var choice_texts = [
		tr("TestScene.ChoiceAWithAnswer"),
		tr("TestScene.ChoiceBWithAnswer"),
		tr("TestScene.ChoiceCWithAnswer"),
		tr("TestScene.ChoiceDWithAnswer"),
	]
	
	for i in range(_choices.size()):
		var btn = answer_buttons[i]
		btn.text = choice_texts[i] % (_choices[i].to_string())
	
	question_clock.clock_time = _choices[_answer_at]
	
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
