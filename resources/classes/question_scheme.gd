extends RefCounted
class_name QuestionScheme

enum QuestionType {
	CLOCK_TO_DIGITAL_CHOICE,
	DIGITAL_TO_CLOCK_CHOICE,
	CLOCK_TO_DIGITAL_SET,
	DIGITAL_TO_CLOCK_SET,
}

var type: QuestionType
var difficulty: int
var time: float
	
func _init(
	_type: QuestionType = QuestionType.CLOCK_TO_DIGITAL_CHOICE,
	_difficulty: int = 1,
	_time: float = -1,
) -> void:
	type = _type
	difficulty = _difficulty
	time = _time
