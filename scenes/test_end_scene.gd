extends Control

@export var subtitle_label: Label
@export var score_label: Label

func _ready() -> void:
	_render_score()

func _render_score() -> void:
	subtitle_label.text = tr(Global.question_name)
	
	var score = Global.test_score
	var max_score = Global.test_max_score
	score_label.text = str(score) + "/" + str(max_score)


func _on_retry_button_pressed() -> void:
	Global.on_change_scene.emit("test_setting")
	
func _on_back_button_pressed() -> void:
	Global.on_change_scene.emit("home")
