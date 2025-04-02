extends Control

func _on_back_button_pressed() -> void:
	Global.on_change_scene.emit("home")

func _to_test_scene() -> void:
	Global.on_change_scene.emit("test_prepare")
	
func _on_level_1_button_pressed() -> void:
	var test_question : Array[QuestionScheme] = []
	var question_type = QuestionScheme.QuestionType.CLOCK_TO_DIGITAL_CHOICE
	var timeout = _get_default_time(question_type)
	for i in range(10):
		test_question.append_array([
			QuestionScheme.new(question_type, i, timeout),
			QuestionScheme.new(question_type, i, timeout),
		])
	Global.test_questions = test_question
	Global.question_name = "อ่านนาฬิกาเข็ม"
	Global.question_description = "มีนาฬิกาเข็มเรือนหนึ่งตั้งอยู่\nเลือกคำตอบเวลาที่ถูกต้องเพียงหนึ่งเดียวจากคำตอบ 4 ตัวเลือก"
	_to_test_scene()


func _on_level_2_button_pressed() -> void:
	var test_question : Array[QuestionScheme] = []
	var question_type = QuestionScheme.QuestionType.DIGITAL_TO_CLOCK_CHOICE
	var timeout = _get_default_time(question_type)
	for i in range(10):
		test_question.append_array([
			QuestionScheme.new(question_type, i, timeout),
			QuestionScheme.new(question_type, i, timeout),
		])
	Global.test_questions = test_question
	Global.question_name = "เทียบนาฬิกาเข็ม"
	Global.question_description = "เลือกนาฬิกาที่เวลาถูกต้องกับข้อความที่แสดงพียงหนึ่งเดียวจากนาฬิกา 4 เรือน"
	_to_test_scene()


func _on_level_3_button_pressed() -> void:
	var test_question : Array[QuestionScheme] = []
	var question_type = QuestionScheme.QuestionType.CLOCK_TO_DIGITAL_SET
	var timeout = _get_default_time(question_type)
	for i in range(10):
		test_question.append_array([
			QuestionScheme.new(question_type, i, timeout),
			QuestionScheme.new(question_type, i, timeout),
		])
	Global.test_questions = test_question
	Global.question_name = "ตั้งนาฬิกาดิจิตอล"
	Global.question_description = "มีนาฬิกาเข็มเรือนหนึ่งตั้งอยู่\nให้ตั้งนาฬิกาดิจิทัลให้เวลาตรงกับเรือนแรก"
	_to_test_scene()


func _on_level_4_button_pressed() -> void:
	var test_question : Array[QuestionScheme] = []
	var question_type = QuestionScheme.QuestionType.DIGITAL_TO_CLOCK_SET
	var timeout = _get_default_time(question_type)
	for i in range(10):
		test_question.append_array([
			QuestionScheme.new(question_type, i, timeout),
			QuestionScheme.new(question_type, i, timeout),
		])
	Global.test_questions = test_question
	Global.question_name = "ตั้งนาฬิกาเข็ม"
	Global.question_description = "มีนาฬิกาดิจิทัลหนึ่งตั้งอยู่\nให้ตั้งนาฬิกาเข็มเรือนให้เวลาตรงกับเรือนแรก"
	_to_test_scene()

func _get_default_time(type: QuestionScheme.QuestionType) -> float:
	if Global.UNLIMITED_TIME_FLAG:
		return -1
	
	if type == QuestionScheme.QuestionType.CLOCK_TO_DIGITAL_CHOICE:
		return 30.0
	elif type ==  QuestionScheme.QuestionType.DIGITAL_TO_CLOCK_CHOICE:
		return 60.0
	elif type ==  QuestionScheme.QuestionType.CLOCK_TO_DIGITAL_SET:
		return 45.0
	elif type ==  QuestionScheme.QuestionType.DIGITAL_TO_CLOCK_SET:
		return 60.0
	
	return 30.0
