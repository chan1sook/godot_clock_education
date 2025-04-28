extends Resource

class_name ClockTimeToReadText

# Basic formal English read time
func to_text(time: ClockTimeResource) -> String:
	var text_result: String = ""
	for text in to_text_tokens(time):
		text_result += text.text
	
	text_result = text_result.substr(0, 1).capitalize() + text_result.substr(1)
	return text_result

func to_text_tokens(time: ClockTimeResource) -> Array[ReadTextData]:
	var tokens: Array[ReadTextData] = _digit_to_text_tokens(time.hour)
	tokens.append(ReadTextData.new(" ", "", true))
	
	if time.minute > 0:
		tokens.append_array(_digit_to_text_tokens(time.minute))
	else:
		tokens.append(ReadTextData.new("O'clock", "en/101_en_o_clock"))
	
	return tokens

func to_voice_tokens(time: ClockTimeResource) -> Array[ReadTextData]:
	var text_tokens = to_text_tokens(time)
	# remove "-"
	text_tokens = text_tokens.filter(func(v): return v.text != "-")
	return text_tokens

# Tokenize number to ...
func _digit_to_text_tokens(n: int) -> Array[ReadTextData]:
	var result: Array[ReadTextData] = []
	if n == 0:
		result.append(ReadTextData.new("zero", "en/200_en_zero"))
	elif n == 1:
		result.append(ReadTextData.new("one", "en/201_en_one"))
	elif n == 2:
		result.append(ReadTextData.new("two", "en/202_en_two"))
	elif n == 3:
		result.append(ReadTextData.new("three", "en/203_en_three"))
	elif n == 4:
		result.append(ReadTextData.new("four", "en/204_en_four"))
	elif n == 5:
		result.append(ReadTextData.new("five", "en/205_en_five"))
	elif n == 6:
		result.append(ReadTextData.new("six", "en/206_en_six"))
	elif n == 7:
		result.append(ReadTextData.new("seven", "en/207_en_seven"))
	elif n == 8:
		result.append(ReadTextData.new("eight", "en/208_en_eight"))
	elif n == 9:
		result.append(ReadTextData.new("nine", "en/209_en_nine"))
	elif n == 10:
		result.append(ReadTextData.new("ten", "en/210_en_ten"))
	elif n == 11:
		result.append(ReadTextData.new("eleven", "en/211_en_eleven"))
	elif n == 12:
		result.append(ReadTextData.new("twelve", "en/212_en_twelve"))
	elif n == 13:
		result.append(ReadTextData.new("thirteen", "en/213_en_thirteen"))
	elif n == 14:
		result.append(ReadTextData.new("fourteen", "en/214_en_fourteen"))
	elif n == 15:
		result.append(ReadTextData.new("fifteen", "en/215_en_fifteen"))
	elif n == 16:
		result.append(ReadTextData.new("sixteen", "en/216_en_sixteen"))
	elif n == 17:
		result.append(ReadTextData.new("seventeen", "en/217_en_seventeen"))
	elif n == 18:
		result.append(ReadTextData.new("eighteen", "en/218_en_eighteen"))
	elif n == 19:
		result.append(ReadTextData.new("ninteen", "en/219_en_ninteen"))
	elif n >= 20:
		var f = n / 10
		if f == 2:
			result.append(ReadTextData.new("twenty", "en/220_en_twenty"))
		elif f == 3:
			result.append(ReadTextData.new("thirty", "en/230_en_thirty"))
		elif f == 4:
			result.append(ReadTextData.new("forty", "en/240_en_forty"))
		else:
			result.append(ReadTextData.new("fifty", "en/250_en_fifty"))
		var r = n % 10
		if r != 0:
			result.append(ReadTextData.new("-", "", true, 0))
			result.append_array(_digit_to_text_tokens(r))
	return result
