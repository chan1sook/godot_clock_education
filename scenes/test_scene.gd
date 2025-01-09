extends Control

var _rng = RandomNumberGenerator.new()

@onready var _number_label = $HBoxContainer/NumberLabel
@onready var _question_timer = $HBoxContainer/TimerBar
@onready var _clock_to_digital_choice_question = $ClockToDigitalChoiceQuestion
@onready var _digital_to_clock_choice_question = $DigitalToClockChoiceQuestion
@onready var _clock_to_digital_question = $ClockToDigitalQuestion
@onready var _digital_to_clock_question = $DigitalToClockQuestion

var _question_list : Array[QuestionScheme] = []

var _question_no: int = 0
var _score: int = 0

func _ready() -> void:
	_question_list = Global.test_questions.slice(0)
	_new_question()

func _process(delta: float) -> void:
	pass

func _new_question() -> void:
	if _question_no >= _question_list.size():
		# No more question
		print("Score:" , _score)
		Global.test_score = _score
		Global.test_max_score = _question_list.size()
		get_tree().change_scene_to_file("res://scenes/test_end_scene.tscn")
		return
	else:
		_question_no += 1
	
	var _question_scheme = _question_list[_question_no - 1]
	
	_number_label.text = str(_question_no) + "/" + str(_question_list.size())
	
	_toggle_question_scenes_visibility()
	
	if _question_scheme.type == QuestionScheme.QuestionType.DIGITAL_TO_CLOCK_CHOICE:
		var choice_data = _generate_clock_choice_question(_question_scheme.difficulty)
		_digital_to_clock_choice_question.register_question(choice_data.choices, choice_data.answer_at)
	elif _question_scheme.type == QuestionScheme.QuestionType.CLOCK_TO_DIGITAL_SET:
		var right_answer = ClockTimeResource.random(_question_scheme.difficulty)
		_clock_to_digital_question.register_question(right_answer)
	elif _question_scheme.type == QuestionScheme.QuestionType.DIGITAL_TO_CLOCK_SET:
		var right_answer = ClockTimeResource.random(_question_scheme.difficulty)
		_digital_to_clock_question.register_question(right_answer)
	else:
		var choice_data = _generate_clock_choice_question(_question_scheme.difficulty)
		_clock_to_digital_choice_question.register_question(choice_data.choices, choice_data.answer_at)
	
	_question_timer.start_time(_question_scheme.time)
	pass

func _generate_clock_choice_question(difficulty: int = -1) -> GeneratedChoiceData:
	var choices = _generate_choices(difficulty)
	var answer_at = _rng.randi_range(0, choices.size() - 1)
	return GeneratedChoiceData.new(choices, answer_at)

func _toggle_question_scenes_visibility() -> void:
	var _question_scheme = _question_list[_question_no - 1]
	
	_clock_to_digital_choice_question.visible = (_question_scheme.type == QuestionScheme.QuestionType.CLOCK_TO_DIGITAL_CHOICE)
	_digital_to_clock_choice_question.visible = (_question_scheme.type == QuestionScheme.QuestionType.DIGITAL_TO_CLOCK_CHOICE)
	_clock_to_digital_question.visible = (_question_scheme.type == QuestionScheme.QuestionType.CLOCK_TO_DIGITAL_SET)
	_digital_to_clock_question.visible = (_question_scheme.type == QuestionScheme.QuestionType.DIGITAL_TO_CLOCK_SET)
	
func _generate_choices(difficulty: int = -1) -> Array[ClockTimeResource]:
	var right_answer = ClockTimeResource.random(difficulty)
	var result_arr : Array[ClockTimeResource] = [right_answer]
	while result_arr.size() < 4:
		var new_time = ClockTimeResource.random(difficulty)
		var allow_add = true
		for old_time in result_arr:
			if new_time.equals_clock(old_time):
				allow_add = false
				break
		if allow_add:
			result_arr.append(new_time)
	result_arr.shuffle()
	return result_arr
	
func _format_clock_str(hour: int, minute: int) -> String:
	var result = str(hour) + ":"
	if minute < 10:
		result += "0"
	result += str(minute)
	return result

func _on_back_button_pressed() -> void:
	print("Pressed")
	get_tree().change_scene_to_file("res://scenes/test_setting_scene.tscn")
	pass 


func _on_question_timer_timeout() -> void:
	# skip question
	_new_question()
	pass 

func _on_choose_answer_result(correct: bool, answer: ClockTimeResource) -> void:
	print("Answer:", answer)
	if correct:
		print("Correct")
		_score += 1
	else:
		print("Wrong")
	
	_new_question()
	pass
