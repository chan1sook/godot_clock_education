extends ClockTimeToText

class_name ClockTimeToTextInformal1

# Informal thai text 1
# Ref: http://legacy.orst.go.th/wp-content/uploads/2018/06/%E0%B9%80%E0%B8%A7%E0%B8%A5%E0%B8%B2%E0%B9%83%E0%B8%99%E0%B8%A0%E0%B8%B2%E0%B8%A9%E0%B8%B2%E0%B9%84%E0%B8%97%E0%B8%A21.pdf
func to_text(time: ClockTimeResource) -> String:
	var result_str = ""
	if time.hour == 0 or time.hour == 24:
		result_str += "เที่ยงคืน"
	elif time.hour >= 1 and time.hour <= 5:
		result_str += "ตี" + _digit_to_text_read(time.hour)
	elif time.hour >= 6 and time.hour <= 11:
		result_str += _digit_to_text_read(time.hour) + "โมงเช้า"
	elif time.hour == 12:
		result_str += "เที่ยงวัน"
	elif time.hour == 13:
		result_str += "บ่ายโมง"
	elif time.hour >= 14 and time.hour <= 15:
		result_str += "บ่าย" + _digit_to_text_read(time.hour - 12) + "โมง"
	elif time.hour >= 16 and time.hour <= 18:
		result_str += _digit_to_text_read(time.hour - 12) + "โมงเย็น"
	elif time.hour >= 19 and time.hour <= 23:
		result_str += _digit_to_text_read(time.hour - 18) + "ทุ่ม"
		
	if time.minute > 0:
		# special case
		if time.minute == 30:
			result_str += "ครึ่ง"
		else:
			result_str += " " + _digit_to_text_read(time.minute) + "นาที"
		
	return result_str
