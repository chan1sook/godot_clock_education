extends ClockTimeToReadText

class_name ClockTimeToReadThaiText

func to_text(time: ClockTimeResource) -> String:
	var text_result: String = ""
	for text in to_text_tokens(time):
		text_result += text.text
	return text_result
	
func to_text_tokens(time: ClockTimeResource) -> Array[ReadTextData]:
	var tokens: Array[ReadTextData] = _digit_to_text_tokens(time.hour)
	tokens.append(ReadTextData.new("นาฬิกา", "th/101_th_hour"))
	
	if time.minute > 0:
		tokens.append(ReadTextData.new(" ", "", true))
		tokens.append_array(_digit_to_text_tokens(time.minute))
		tokens.append(ReadTextData.new("นาที", "th/102_th_minute"))
		
	return tokens

func to_voice_tokens(time: ClockTimeResource) -> Array[ReadTextData]:
	return to_text_tokens(time)
	
func _digit_to_text_tokens(n: int) -> Array[ReadTextData]:
	var result: Array[ReadTextData] = []
	if n == 0:
		result.append(ReadTextData.new("ศูนย์", "th/200_th_zero"))
	elif n == 1:
		result.append(ReadTextData.new("หนึ่ง", "th/201_th_one"))
	elif n == 2:
		result.append(ReadTextData.new("สอง", "th/202_th_two"))
	elif n == 3:
		result.append(ReadTextData.new("สาม", "th/203_th_three"))
	elif n == 4:
		result.append(ReadTextData.new("สี่", "th/204_th_four"))
	elif n == 5:
		result.append(ReadTextData.new("ห้า", "th/205_th_five"))
	elif n == 6:
		result.append(ReadTextData.new("หก", "th/206_th_six"))
	elif n == 7:
		result.append(ReadTextData.new("เจ็ด", "th/207_th_seven"))
	elif n == 8:
		result.append(ReadTextData.new("แปด", "th/208_th_eight"))
	elif n == 9:
		result.append(ReadTextData.new("เก้า", "th/209_th_nine"))
	elif n >= 10:
		var r = n % 10
		if r == 0:
			if n == 10:
				result.append(ReadTextData.new("สิบ", "th/210_th_ten"))
			elif n == 20:
				result.append(ReadTextData.new("ยี่สิบ", "th/220_th_twenty"))
			else:
				result.append_array(_digit_to_text_tokens(n / 10))
				result.append_array(_digit_to_text_tokens(10))
		elif r == 1:
			result.append_array(_digit_to_text_tokens(n - r))
			result.append(ReadTextData.new("เอ็ด", "th/211_th_one_11"))
		else:
			result.append_array(_digit_to_text_tokens(n - r))
			result.append_array(_digit_to_text_tokens(r))
	return result
