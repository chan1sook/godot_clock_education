class_name ClockTimeResource
extends Resource

const _MAX_TIME_UNIT = 60 * 24
@export_range(0, 23) var hour: int = 0
@export_range(0, 59) var minute: int = 0

func _init(_hour: int = 0, _minute: int = 0) -> void:
	hour = _hour
	minute = _minute
	pass

func _to_string():
	return _format_clock_str(hour, minute)

func _format_clock_str(hour: int, minute: int) -> String:
	var result = ""
	if hour < 10:
		result += "0"
	result += str(hour) + ":"
	if minute < 10:
		result += "0"
	result += str(minute)
	return result
	
func get_time_unit() -> int:
	return hour * 60 + minute

func set_time_unit(time_unit: int) -> void:
	minute = time_unit % 60
	@warning_ignore("integer_division")
	var time_unit_2 = (time_unit - minute) / 60
	if time_unit_2 < 0:
		hour = ceili(time_unit_2)
	else:
		hour = floori(time_unit_2)
	pass

func normalize() -> void:
	var time_unit_normalized = get_time_unit()
	time_unit_normalized %= _MAX_TIME_UNIT
	if time_unit_normalized < 0:
		time_unit_normalized += _MAX_TIME_UNIT
	set_time_unit(time_unit_normalized)
	pass

func clone() -> ClockTimeResource:
	return ClockTimeResource.new(hour, minute)


func equals_clock(other: ClockTimeResource) -> bool:
	var a = self.clone()
	a.normalize()
	var b = other.clone()
	b.normalize()
		
	return a.minute == b.minute and (a.hour % 12) == (b.hour % 12)

static func random(difficulty :int = -1) -> ClockTimeResource:
	var rng = RandomNumberGenerator.new()
	var result = ClockTimeResource.new()
	if difficulty >= 0 and difficulty <= 4:
		result.hour = rng.randi_range(1, 12)
	elif difficulty >= 5 and difficulty <= 7:
		result.hour = rng.randi_range(13, 24)
	else:
		result.hour = rng.randi_range(0, 23)
	
	if difficulty == 0:
		result.minute = 0
	elif difficulty == 1:
		result.minute = 30
	elif difficulty == 2:
		result.minute = rng.randi_range(0, 1) * 30 + 15 # (0, 30) + 15
	elif difficulty == 3:
		result.minute = rng.randi_range(0, 3) * 15 + (rng.randi_range(1, 2) * 5) # (0, 15, 30, 45) + (5, 10)
	elif difficulty == 4:
		result.minute = rng.randi_range(0, 11) * 5 + rng.randi_range(1, 4) # (0, 5, ..., 55) + (1, 4)
	elif difficulty == 5:
		result.minute = rng.randi_range(0, 3) * 15
	elif difficulty == 6:
		result.minute = rng.randi_range(0, 3) * 15 + (rng.randi_range(1, 2) * 5) # (0, 15, 30, 45) + (5, 10)
	elif difficulty == 7:
		result.minute = rng.randi_range(0, 11) * 5 + rng.randi_range(1, 4) # (0, 5, ..., 55) + (1, 4)
	else:
		result.minute = rng.randi_range(0, 59)
		
	result.normalize()
	return result
