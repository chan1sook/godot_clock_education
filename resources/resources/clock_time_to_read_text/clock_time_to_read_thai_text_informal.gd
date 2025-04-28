extends ClockTimeToReadThaiText

class_name ClockTimeToReadThaiInformalText

# Informal thai text 1
# Ref: http://legacy.orst.go.th/wp-content/uploads/2018/06/%E0%B9%80%E0%B8%A7%E0%B8%A5%E0%B8%B2%E0%B9%83%E0%B8%99%E0%B8%A0%E0%B8%B2%E0%B8%A9%E0%B8%B2%E0%B9%84%E0%B8%97%E0%B8%A21.pdf
func to_text_tokens(time: ClockTimeResource) -> Array[ReadTextData]:
	var tokens: Array[ReadTextData] = []
	if time.hour == 0 or time.hour == 24:
		tokens.append(ReadTextData.new("เที่ยงคืน", "th/104_th_midnight"))
	elif time.hour >= 1 and time.hour <= 5:
		tokens.append(ReadTextData.new("ตี", "th/105_th_hour_night_am"))
		tokens.append_array(_digit_to_text_tokens(time.hour))
	elif time.hour >= 6 and time.hour <= 11:
		tokens.append_array(_digit_to_text_tokens(time.hour))
		tokens.append(ReadTextData.new("โมง", "th/106_th_hour_day"))
		tokens.append(ReadTextData.new("เช้า", "th/107_th_day_am"))
	elif time.hour == 12:
		tokens.append(ReadTextData.new("เที่ยงวัน", "th/103_th_noon"))
	elif time.hour == 13:
		tokens.append(ReadTextData.new("บ่าย", "th/108_th_day_pm"))
		tokens.append(ReadTextData.new("โมง", "th/106_th_hour_day"))
	elif time.hour >= 14 and time.hour <= 15:
		tokens.append(ReadTextData.new("บ่าย", "th/108_th_day_pm"))
		tokens.append_array(_digit_to_text_tokens(time.hour - 12))
		tokens.append(ReadTextData.new("โมง", "th/106_th_hour_day"))
	elif time.hour >= 16 and time.hour <= 18:
		tokens.append_array(_digit_to_text_tokens(time.hour - 12))
		tokens.append(ReadTextData.new("โมง", "th/106_th_hour_day"))
		tokens.append(ReadTextData.new("เย็น", "th/109_th_day_sunset"))
	elif time.hour >= 19 and time.hour <= 23:
		tokens.append_array(_digit_to_text_tokens(time.hour - 18))
		tokens.append(ReadTextData.new("ทุ่ม", "th/110_th_hour_night_pm"))
		
	if time.minute > 0:
		# special case
		if time.minute == 30:
			tokens.append(ReadTextData.new("ครึ่ง", "th/111_th_half"))
		else:
			tokens.append(ReadTextData.new(" ", "", true))
			tokens.append_array(_digit_to_text_tokens(time.minute))
			tokens.append(ReadTextData.new("นาที", "th/102_th_minute"))
	return tokens
