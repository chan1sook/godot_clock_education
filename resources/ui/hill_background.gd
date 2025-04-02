extends Control

@export var cloud_speeds: Array[float]

@export_group("Nodes")
@export var clouds: Array[Sprite2D]

func _ready() -> void:
	for cloud in clouds:
		var rect = cloud.get_rect()
		var x_min = -rect.size.x
		var x_max = get_viewport_rect().size.x + rect.size.x
		cloud.global_position.x = randf_range(x_min, x_max)
	
func _process(delta: float) -> void:
	for i in range(clouds.size()):
		var cloud = clouds[i]
		cloud.global_position.x -= cloud_speeds[i] * delta
		var rect = cloud.get_rect()
		var x_check = cloud.global_position.x + rect.size.x
		if x_check < 0:
			cloud.global_position.x = get_viewport_rect().size.x + rect.size.x
