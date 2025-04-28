extends ClockTimeToReadText

class_name ClockTimeToReadInformalText

func to_text_tokens(time: ClockTimeResource) -> Array[ReadTextData]:
	var tokens: Array[ReadTextData] = []
	if time.minute == 0:
		if time.hour % 24 == 0:
			tokens.append(ReadTextData.new("midnight", "en/107_en_midnight"))
		elif time.hour % 24 == 12:
			tokens.append(ReadTextData.new("noon", "en/106_en_noon"))
		else:
			tokens.append_array(_digit_to_text_tokens(time.hour))
			tokens.append(ReadTextData.new(" ", "", true, 0))
			tokens.append(ReadTextData.new("O'clock", "en/101_en_o_clock"))
	elif time.minute == 30:
		tokens.append(ReadTextData.new("half", "en/102_en_half"))
		tokens.append(ReadTextData.new(" ", "", true, 0))
		tokens.append(ReadTextData.new("past"))
		tokens.append(ReadTextData.new(" ", "", true, 0))
		tokens.append_array(_digit_to_text_tokens(time.hour))
	elif time.minute == 15:
		tokens.append(ReadTextData.new("quarter", "en/103_en_quarter"))
		tokens.append(ReadTextData.new(" ", "", true, 0))
		tokens.append(ReadTextData.new("past", "en/105_en_past"))
		tokens.append(ReadTextData.new(" ", "", true, 0))
		tokens.append_array(_digit_to_text_tokens(time.hour))
	elif time.minute == 45:
		tokens.append(ReadTextData.new("quarter", "en/103_en_quarter"))
		tokens.append(ReadTextData.new(" ", "", true, 0))
		tokens.append(ReadTextData.new("to", "en/104_en_to"))
		tokens.append(ReadTextData.new(" ", "", true, 0))
		tokens.append_array(_digit_to_text_tokens((time.hour + 1) % 24))
	elif time.minute < 30:
		tokens.append_array(_digit_to_text_tokens(time.minute))
		tokens.append(ReadTextData.new(" ", "", true, 0))
		tokens.append(ReadTextData.new("past", "en/105_en_past"))
		tokens.append(ReadTextData.new(" ", "", true, 0))
		tokens.append_array(_digit_to_text_tokens(time.hour))
	else:
		tokens.append_array(_digit_to_text_tokens(60 - time.minute))
		tokens.append(ReadTextData.new(" ", "", true, 0))
		tokens.append(ReadTextData.new("to", "en/104_en_to"))
		tokens.append(ReadTextData.new(" ", "", true, 0))
		tokens.append_array(_digit_to_text_tokens((time.hour + 1) % 24))
	return tokens
