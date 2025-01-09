@tool

class_name ClockNode
extends Control

const _MAX_TIME_UNIT = 60 * 24

signal time_changed(time: ClockTimeResource)

@export var clock_time : ClockTimeResource = ClockTimeResource.new(0, 0)

@export var interactable: bool = true

@onready var _hour_hand : Control = $HourHand
@onready var _hour_hand_area : Area2D = $HourHand/Pivot/HourHandArea2D
@onready var _hour_pivot : Control = $HourHand/Pivot

@onready var _minute_hand : Control = $MinuteHand
@onready var _minute_hand_area : Area2D = $MinuteHand/Pivot/MinuteHandArea2D
@onready var _minute_pivot : Control = $MinuteHand/Pivot

var _is_draging_minute_hand : bool = false
var _is_draging_hour_hand : bool = false

func _ready() -> void:
	_render_clock()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_render_clock()
	elif _is_draging_minute_hand:
		_on_drag_minute_hand()
	elif _is_draging_hour_hand:
		_on_drag_hour_hand()
	else:
		_render_clock()
	pass

func _input(event) -> void:
	if not Engine.is_editor_hint() and interactable and event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and not event.pressed:
		_is_draging_minute_hand = false
		_is_draging_hour_hand = false
		pass
	pass

func _calulate_angle_deg_diff(clock_hand: Control, pivot: Control) -> float:
	var target_angle_rad = clock_hand.get_local_mouse_position().angle()
	var target_angle_clock_deg = rad_to_deg(target_angle_rad) + 90
	var angle_diff_deg = (target_angle_clock_deg - pivot.rotation_degrees)
	if angle_diff_deg < -180:
		angle_diff_deg += 360
	return angle_diff_deg

func _on_drag_minute_hand() -> void:
	var angle_diff_deg = _calulate_angle_deg_diff(_minute_hand, _minute_pivot)
	var minute_min_deg : float = 6.0
	if abs(angle_diff_deg) >= minute_min_deg:
		var minute_diff = 0
		if angle_diff_deg < 0:
			minute_diff = ceil(angle_diff_deg / minute_min_deg)
		else:
			minute_diff = floor(angle_diff_deg / minute_min_deg)
		clock_time.minute += minute_diff
		clock_time.normalize()
		time_changed.emit(clock_time.clone())
		_render_clock()
		pass
	pass
	
func _on_drag_hour_hand() -> void:
	var angle_diff_deg = _calulate_angle_deg_diff(_hour_hand, _hour_pivot)
	var hour_min_deg : float = 0.5
	if abs(angle_diff_deg) >= hour_min_deg:
		var minute_diff = 0
		if angle_diff_deg < 0:
			minute_diff = ceil(angle_diff_deg / hour_min_deg)
		else:
			minute_diff = floor(angle_diff_deg / hour_min_deg)
		
		clock_time.minute += minute_diff
		clock_time.normalize()
		time_changed.emit(clock_time.clone())
		_render_clock()
		pass
	pass

func _render_clock(realistic : bool = true) -> void:
	var minute_angle_deg : float = clock_time.minute * 6.0
	_minute_pivot.rotation_degrees = minute_angle_deg
	
	var hour_angle_deg : float = clock_time.hour * 30.0 # with realistic
	if realistic:
		hour_angle_deg += clock_time.minute * 0.5 
	_hour_hand.rotation_degrees = hour_angle_deg
	
	_hour_hand_area.visible = interactable
	_minute_hand_area.visible = interactable
	pass

@warning_ignore("unused_parameter")
func _on_minute_hand_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not Engine.is_editor_hint() and interactable and event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
		_is_draging_minute_hand = true
	pass

@warning_ignore("unused_parameter")
func _on_hour_hand_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not Engine.is_editor_hint() and interactable and event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
		_is_draging_hour_hand = true
	pass
