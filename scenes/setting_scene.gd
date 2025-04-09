extends Control

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
		language_item_list.add_item(_avaliable_languages[lang])
		
	var old_lang_index =  Global.SUPPORT_LANGUAGES.find(TranslationServer.get_locale())
	if old_lang_index != -1:
		_language_index = old_lang_index
	language_item_list.select(_language_index)
	

func _process(delta: float) -> void:
	var lang = Global.SUPPORT_LANGUAGES[_language_index]
	language_label.text = _avaliable_languages[lang]

func _init_language_dict():
	for lang in Global.SUPPORT_LANGUAGES:
		var translate_obj = TranslationServer.get_translation_object(lang)
		_avaliable_languages[lang] = translate_obj.get_message("Game.Language.Name")
	
func _on_back_button_pressed() -> void:
	Global.on_change_scene.emit("home")

func _on_language_item_list_item_selected(index: int) -> void:
	_language_index = index
	var lang = Global.SUPPORT_LANGUAGES[index]
	TranslationServer.set_locale(lang)
