extends Control

var _is_syncing_time: bool = false

@export var start_time: ClockTimeResource = ClockTimeResource.new(8, 0)
@onready var clock: ClockNode = $Clock
@onready var digital_clock_input: DigitalClockInputNode = $DigitalClockInput
@onready var sync_btn: Button = $SyncTimeButton

func _ready() -> void:
	_apply_time_to_clocks(start_time)
	pass

func _process(delta: float) -> void:
	sync_btn.button_pressed = _is_syncing_time
	if _is_syncing_time:
		_apply_time_to_clocks(_get_sync_time())
	pass

func _get_sync_time() -> ClockTimeResource:
	var time_result = Time.get_time_dict_from_system()
	return ClockTimeResource.new(time_result.hour, time_result.minute)
	
func _apply_time_to_clocks(clock_time: ClockTimeResource) -> void:
	clock.clock_time = clock_time
	digital_clock_input.clock_time = clock_time
	
func _on_clock_time_changed(time: ClockTimeResource) -> void:
	_is_syncing_time = false
	digital_clock_input.clock_time = time
	pass

func _on_digital_clock_input_time_changed(time: ClockTimeResource) -> void:
	_is_syncing_time = false
	start_time = time
	clock.clock_time = start_time
	pass

func _on_sync_time_button_pressed() -> void:
	if not _is_syncing_time:
		_apply_time_to_clocks(_get_sync_time())
	else:
		_is_syncing_time = false
	pass


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	pass # Replace with function body.
