extends Node2D

class_name StudentSprite

@export_enum("Boy", "Girl") var gender: String = "Boy"

@export_group("Textures")
@export var boy_texture: Texture2D
@export var girl_texture: Texture2D

@export_group("Nodes")
@export var sprite_2d: Sprite2D
@export var animation_player: AnimationPlayer

var _old_tween: Tween
var _delay: float
var _move_dir: Vector2

func _ready() -> void:
	if gender == "Girl":
		sprite_2d.texture = girl_texture
	else:
		sprite_2d.texture = boy_texture
	
func warp_to(target_global_position: Vector2):
	if _old_tween:
		_old_tween.stop()
	animation_player.play("RESET")
	
	self.global_position = target_global_position

func walk_to(target_global_position: Vector2, speed: float = 60.0) -> float:
	_move_dir = target_global_position - self.global_position
	var duration = _move_dir.length() / speed
	_turn_texture()
	animation_player.play("RESET")
	if _old_tween:
		_old_tween.stop()
	return duration

func hop_to(
	target_global_position: Vector2, 
	delay: float = 0.0,
	max_hop_distance: float = 200.0
) -> float:
	_move_dir = target_global_position - self.global_position
	var hop_cnt = ceil(_move_dir.length() / max_hop_distance)
	var duration = 0.3 * hop_cnt
	if _old_tween:
		_old_tween.stop()
	_old_tween = create_tween()
	_old_tween.tween_interval(delay)
	_old_tween.tween_callback(_play_jump_animation)
	_old_tween.tween_property(self, "global_position", target_global_position, duration).from(self.global_position)
	_old_tween.tween_callback(_reset_animation)
	return duration + delay
	

func low_hop_to(
	target_global_position: Vector2, 
	delay: float = 0.0,
	max_hop_distance: float = 200.0
) -> float:
	_move_dir = target_global_position - self.global_position
	var hop_cnt = ceil(_move_dir.length() / max_hop_distance)
	var duration = 0.3 * hop_cnt
	if _old_tween:
		_old_tween.stop()
	_old_tween = create_tween()
	_old_tween.tween_interval(delay)
	_old_tween.tween_callback(_play_low_jump_animation)
	_old_tween.tween_property(self, "global_position", target_global_position, duration).from(self.global_position)
	_old_tween.tween_callback(_reset_animation)
	return duration + delay


func _turn_texture():
	sprite_2d.flip_h = _move_dir.x < 0

func _play_jump_animation():
	animation_player.play("jump")
	_turn_texture()
	
func _play_low_jump_animation():
	animation_player.play("jump_lower")
	_turn_texture()
	
func _reset_animation():
	animation_player.play("RESET")
