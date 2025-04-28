extends Control

@export var language_flag_container: Control
@export var language_flag: TextureRect
@export var language_label: Label
@export var language_item_list: ItemList

var _avaliable_languages = {
	"th": tr("Game.Language.Name")
} # String : String

var _language_index = 0

func _ready() -> void:
	_init_language_dict()
	
	language_item_list.clear()
	for lang in Global.SUPPORT_LANGUAGES:
		var img = _get_flag_resource(lang)
		language_item_list.add_item(_avaliable_languages[lang], img)
		
	var old_lang_index =  Global.SUPPORT_LANGUAGES.find(TranslationServer.get_locale())
	if old_lang_index != -1:
		_language_index = old_lang_index
	language_item_list.select(_language_index)
	_swap_language_labels()
	
func _init_language_dict():
	for lang in Global.SUPPORT_LANGUAGES:
		var translate_obj = TranslationServer.get_translation_object(lang)
		_avaliable_languages[lang] = translate_obj.get_message("Game.Language.Name")

func _get_flag_resource(lang: String) -> Texture2D:
	return ResourceLoader.load("res://assets/images/lang_flag/%s.svg" % [lang]) as Texture2D

func _swap_language_labels():
	var lang = Global.SUPPORT_LANGUAGES[_language_index]
	language_label.text = _avaliable_languages[lang]
	var img = _get_flag_resource(lang)
	language_flag.texture = img
	language_flag_container.visible = not not img

func _on_back_button_pressed() -> void:
	Global.on_change_scene.emit("home")

func _on_language_item_list_item_selected(index: int) -> void:
	_language_index = index
	var lang = Global.SUPPORT_LANGUAGES[index]
	Global.app_lang = lang
	_swap_language_labels()
