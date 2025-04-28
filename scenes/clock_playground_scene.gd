extends Control

var _is_syncing_time: bool = false

@export var start_time: ClockTimeResource = ClockTimeResource.new(8, 0)

@export_group("Clock Nodes")
@export var clock: ClockNode
@export var digital_clock_input: DigitalClockInputNode
@export var sync_btn: Button

func _ready() -> void:
	start_time = Global.read_clock_time.clone()
	
	_apply_time_to_clocks(start_time)

func _process(delta: float) -> void:
	sync_btn.button_pressed = _is_syncing_time
	if _is_syncing_time:
		_apply_time_to_clocks(_get_sync_time())

func _get_sync_time() -> ClockTimeResource:
	var time_result = Time.get_time_dict_from_system()
	return ClockTimeResource.new(time_result.hour, time_result.minute)
	
func _apply_time_to_clocks(clock_time: ClockTimeResource) -> void:
	clock.clock_time = clock_time
	digital_clock_input.clock_time = clock_time
	
func _on_clock_time_changed(time: ClockTimeResource) -> void:
	_is_syncing_time = false
	digital_clock_input.clock_time = time

func _on_digital_clock_input_time_changed(time: ClockTimeResource) -> void:
	_is_syncing_time = false
	start_time = time
	clock.clock_time = start_time

func _on_sync_time_button_pressed() -> void:
	if not _is_syncing_time:
		_apply_time_to_clocks(_get_sync_time())
	else:
		_is_syncing_time = false

func _on_back_button_pressed() -> void:
	Global.on_change_scene.emit("home")

func _on_read_clock_scene_button_pressed() -> void:
	Global.read_clock_time = clock.clock_time.clone()
	Global.on_change_scene.emit("read_clock")
