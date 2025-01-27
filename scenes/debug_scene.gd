extends Control

func _ready() -> void:
	var v = ClockTimeToText.new()
	var v2 = ClockTimeToTextInformal1.new()
	
	var time_result = Time.get_time_dict_from_system()
	var time = ClockTimeResource.new(time_result.hour, time_result.minute)
	print(time, " => ", v.to_text(time), " | ", v2.to_text(time))
	for i in range(0, 30):
		var t = ClockTimeResource.random()
		print(t, " => ", v.to_text(t), " | ", v2.to_text(t))
