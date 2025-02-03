extends ClockTimeToText

class_name ClockTimeToTextInformal1

# Informal thai text 1
# Ref: http://legacy.orst.go.th/wp-content/uploads/2018/06/%E0%B9%80%E0%B8%A7%E0%B8%A5%E0%B8%B2%E0%B9%83%E0%B8%99%E0%B8%A0%E0%B8%B2%E0%B8%A9%E0%B8%B2%E0%B9%84%E0%B8%97%E0%B8%A21.pdf

func to_text_tokens(time: ClockTimeResource) -> Array[String]:
	var tokens: Array[String] = []
	if time.hour == 0 or time.hour == 24:
		tokens.append("เที่ยง")
		tokens.append("คืน")
	elif time.hour >= 1 and time.hour <= 5:
		tokens.append("ตี")
		tokens.append_array(_digit_to_text_tokens(time.hour))
	elif time.hour >= 6 and time.hour <= 11:
		tokens.append_array(_digit_to_text_tokens(time.hour))
		tokens.append("โมง")
		tokens.append("เช้า")
	elif time.hour == 12:
		tokens.append("เที่ยง")
		tokens.append("วัน")
	elif time.hour == 13:
		tokens.append("บ่าย")
		tokens.append("โมง")
	elif time.hour >= 14 and time.hour <= 15:
		tokens.append("บ่าย")
		tokens.append_array(_digit_to_text_tokens(time.hour - 12))
		tokens.append("โมง")
	elif time.hour >= 16 and time.hour <= 18:
		tokens.append_array(_digit_to_text_tokens(time.hour - 12))
		tokens.append("โมง")
		tokens.append("เย็น")
	elif time.hour >= 19 and time.hour <= 23:
		tokens.append_array(_digit_to_text_tokens(time.hour - 18))
		tokens.append("ทุ่ม")
		
	if time.minute > 0:
		# special case
		if time.minute == 30:
			tokens.append("ครึ่ง")
		else:
			tokens.append(" ")
			tokens.append_array(_digit_to_text_tokens(time.minute))
			tokens.append("นาที")
	return tokens
