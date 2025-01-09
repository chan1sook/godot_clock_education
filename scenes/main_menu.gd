extends Control

@onready var _animation_player = $AnimationPlayer
@onready var _version_label = $VersionLabel

func _ready() -> void:
	_version_label.text = str(Global.VERSION_STR)
	_animation_player.play("intro")
	pass
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()
	pass


func _on_free_mode_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/clock_playground.tscn")
	pass


func _on_trial_mode_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test_setting_scene.tscn")
	pass
