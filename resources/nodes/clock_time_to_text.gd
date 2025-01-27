extends Node

class_name ClockTimeToText

# Formal thai text
func to_text(time: ClockTimeResource) -> String:
	var result_str = _digit_to_text_read(time.hour) + "นาฬิกา"
	if time.minute > 0:
		result_str += " " + _digit_to_text_read(time.minute) + "นาที"
		
	return result_str

# 0-60
func _digit_to_text_read(n: int) -> String:
	if n == 0:
		return "ศูนย์"
	if n == 1:
		return "หนึ่ง"
	if n == 2:
		return "สอง"
	if n == 3:
		return "สาม"
	if n == 4:
		return "สี่"
	if n == 5:
		return "ห้า"
	if n == 6:
		return "หก"
	if n == 7:
		return "เจ็ด"
	if n == 8:
		return "แปด"
	if n == 9:
		return "เก้า"
	if n >= 10:
		var r = n % 10
		if r == 0:
			if n == 10:
				return "สิบ"
			if n == 20:
				return "ยี่" + _digit_to_text_read(10)
			return _digit_to_text_read(n / 10) + _digit_to_text_read(10)
		elif r == 1:
			return _digit_to_text_read(n - r) + "เอ็ด"
		else:
			return _digit_to_text_read(n - r) + _digit_to_text_read(r)
	return ""
