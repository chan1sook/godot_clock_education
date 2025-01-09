extends Control
@onready var score_label: Label = $PanelContainer/VBoxContainer/ScoreLabel

func _ready() -> void:
	_render_score()
	pass


func _process(delta: float) -> void:
	pass

func _render_score() -> void:
	var score = Global.test_score
	var max_score = Global.test_max_score
	score_label.text = str(score) + "/" + str(max_score)
	pass


func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test_scene.tscn")
	pass


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	pass
