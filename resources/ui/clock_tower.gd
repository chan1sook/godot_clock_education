extends Sprite2D

@onready var clock: ClockNode = $Clock

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_sync_time()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_sync_time()

func _sync_time():
	clock.clock_time = _get_sync_time()
	pass

func _get_sync_time() -> ClockTimeResource:
	var time_result = Time.get_time_dict_from_system()
	return ClockTimeResource.new(time_result.hour, time_result.minute)
