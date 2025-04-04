@tool

class_name DigitalClockInputNode
extends HBoxContainer

const _MAX_TIME_UNIT = 60 * 24

signal time_changed(time: ClockTimeResource)

@export var clock_time : ClockTimeResource = ClockTimeResource.new(0, 0)

@onready var _hour_label : Label = $HourInput/PanelContainer/HourLabel
@onready var _minute_label : Label = $MinuteInput/PanelContainer/MinuteLabel

func _ready() -> void:
	_update_clock()

func _process(delta: float) -> void:
	_update_clock()

func _update_clock() -> void:
	_hour_label.text = str(clock_time.hour)
	if clock_time.minute < 10:
		_minute_label.text = "0" + str(clock_time.minute)
	else:
		_minute_label.text = str(clock_time.minute)

func _on_hour_up_button_pressed() -> void:
	clock_time.hour += 1
	clock_time.normalize()
	if not Engine.is_editor_hint():
		time_changed.emit(clock_time.clone())


func _on_hour_down_button_pressed() -> void:
	clock_time.hour -= 1
	clock_time.normalize()
	if not Engine.is_editor_hint():
		time_changed.emit(clock_time.clone())


func _on_minute_up_button_pressed() -> void:
	clock_time.minute += 1
	clock_time.normalize()
	if not Engine.is_editor_hint():
		time_changed.emit(clock_time.clone())


func _on_ten_minute_up_button_pressed() -> void:
	clock_time.minute += 10
	clock_time.normalize()
	if not Engine.is_editor_hint():
		time_changed.emit(clock_time.clone())


func _on_minute_down_button_pressed() -> void:
	clock_time.minute -= 1
	clock_time.normalize()
	if not Engine.is_editor_hint():
		time_changed.emit(clock_time.clone())


func _on_ten_minute_down_button_pressed() -> void:
	clock_time.minute -= 10
	clock_time.normalize()
	if not Engine.is_editor_hint():
		time_changed.emit(clock_time.clone())
