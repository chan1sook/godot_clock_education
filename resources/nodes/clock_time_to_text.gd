extends Node

class_name ClockTimeToText

# Formal thai text
func to_text(time: ClockTimeResource) -> String:
	var text_result: String = ""
	for text in to_text_tokens(time):
		text_result += text
	return text_result

# 0-60
func _digit_to_text_tokens(n: int) -> Array[String]:
	var result: Array[String] = []
	if n == 0:
		result.append("ศูนย์")
	elif n == 1:
		result.append("หนึ่ง")
	elif n == 2:
		result.append("สอง")
	elif n == 3:
		result.append("สาม")
	elif n == 4:
		result.append("สี่")
	elif n == 5:
		result.append("ห้า")
	elif n == 6:
		result.append("หก")
	elif n == 7:
		result.append("เจ็ด")
	elif n == 8:
		result.append("แปด")
	elif n == 9:
		result.append("เก้า")
	elif n >= 10:
		var r = n % 10
		if r == 0:
			if n == 10:
				result.append("สิบ")
			elif n == 20:
				result.append("ยี่")
				result.append_array(_digit_to_text_tokens(10))
			else:
				result.append_array(_digit_to_text_tokens(n / 10))
				result.append_array(_digit_to_text_tokens(10))
		elif r == 1:
			result.append_array(_digit_to_text_tokens(n - r))
			result.append("เอ็ด")
		else:
			result.append_array(_digit_to_text_tokens(n - r))
			result.append_array(_digit_to_text_tokens(r))
	return result

func to_text_tokens(time: ClockTimeResource) -> Array[String]:
	var tokens: Array[String] = _digit_to_text_tokens(time.hour)
	tokens.append("นาฬิกา")
	
	if time.minute > 0:
		tokens.append(" ")
		tokens.append_array(_digit_to_text_tokens(time.minute))
		tokens.append("นาที")
		
	return tokens
