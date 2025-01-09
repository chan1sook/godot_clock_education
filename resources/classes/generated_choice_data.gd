extends RefCounted
class_name GeneratedChoiceData

var choices: Array[ClockTimeResource]
var answer_at: int
	
func _init(
	_choices: Array[ClockTimeResource] = [],
	_answer_at: int = -1,
) -> void:
	choices = _choices
	answer_at = _answer_at
pass
