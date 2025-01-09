extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test_scene.tscn")


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test_setting_scene.tscn")
