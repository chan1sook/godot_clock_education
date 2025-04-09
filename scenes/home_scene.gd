extends Control

@export var student_into_sprites: Array[StudentSprite]
@export var student_intro_tween: Array[RayCast2D]
@export var student_intro_delay: Array[float]
@export var student_idle_tween: Array[RayCast2D]

@export_group("Nodes")
@export var animation_player: AnimationPlayer
@export var version_label: Label

var _animation_phase: String
var _animation_time: float = 0

func _ready() -> void:
	version_label.text = str(Global.VERSION_STR)
	_play_intro()
	
func _play_intro():
	var max_duration = 0
	for i in range(student_into_sprites.size()):
		var student = student_into_sprites[i]
		if student and student_intro_tween[i]:
			var tween = student_intro_tween[i]
			var delay = student_intro_delay[i]
			var start_point = tween.global_position
			var end_point = tween.to_global(tween.target_position)
			student.warp_to(start_point)
			var duration = student.hop_to(end_point, delay)
			max_duration = max(duration, max_duration)
	_animation_time = max(max_duration, 2.5)
	_animation_phase = "intro"
	animation_player.play("intro")

func _start_idle_animation():
	var max_duration = 0
	for i in range(student_into_sprites.size()):
		var student = student_into_sprites[i]
		if student and student_idle_tween[i]:
			var tween = student_idle_tween[i]
			var start_point = student.global_position
			var tween_point = tween.to_global(tween.target_position)
			var dv = tween_point - tween.global_position
			# random dir and in range
			var dist = randf_range(0, dv.length())
			var end_point = start_point + (Vector2.from_angle(randf_range(-PI, PI)) * dist)
			var delay = randf_range(0.2, 3.2)
			var duration = student.low_hop_to(end_point, delay)
			max_duration = max(duration, max_duration)
	_animation_time = max(max_duration, 5)
	_animation_phase = "idle"
	
func _process(delta: float) -> void:
	if _animation_time > 0:
		_animation_time -= delta
		if _animation_time < 0:
			_animation_time = 0
	if _animation_time <= 0:
		if _animation_phase == "intro":
			_start_idle_animation()
		elif _animation_phase == "idle":
			_start_idle_animation()
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_free_mode_button_pressed() -> void:
	Global.on_change_scene.emit("clock_playground")

func _on_trial_mode_button_pressed() -> void:
	Global.on_change_scene.emit("test_setting")

func _on_credit_button_pressed() -> void:
	Global.on_change_scene.emit("credit")
	
func _on_setting_button_pressed() -> void:
	Global.on_change_scene.emit("setting")
