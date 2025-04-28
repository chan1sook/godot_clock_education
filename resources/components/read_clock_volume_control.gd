extends VBoxContainer

class_name VolumeControl

signal volume_changed(value: float)

@export_group("Textures")
@export var volume_full_texture: Texture2D
@export var volume_medium_texture: Texture2D
@export var volume_low_texture: Texture2D
@export var volume_off_texture: Texture2D

@export_group("Nodes")
@export var icon_rect: TextureRect
@export var slider: Slider
@export var percent_label: Label

var volume_percent: float:
	get:
		if slider:
			return slider.value
		return 0
	set(v):
		if slider:
			slider.value = v
		
func _process(delta: float) -> void:
	percent_label.text = "%d%%" % [int(slider.value)]
	
	if slider.value <= 0:
		icon_rect.texture = volume_off_texture
	elif slider.value <= 30:
		icon_rect.texture = volume_low_texture
	elif slider.value <= 70:
		icon_rect.texture = volume_medium_texture
	else:
		icon_rect.texture = volume_full_texture


func _on_volume_slider_value_changed(value: float) -> void:
	volume_changed.emit(value)
