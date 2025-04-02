extends Control

@export_group("Nodes")
@export var subtitle_label: Label
@export var info_label: Label

func _ready() -> void:
	subtitle_label.text = Global.question_name
	info_label.text = Global.question_description

func _on_start_button_pressed() -> void:
	Global.on_change_scene.emit("test")

func _on_back_button_pressed() -> void:
	Global.on_change_scene.emit("test_setting")
