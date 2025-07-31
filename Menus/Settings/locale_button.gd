class_name LocaleButton
extends Button

@export var locale: String


func _on_pressed() -> void:
	if locale.is_empty():
		return
	Settings.preferred_locale = locale
	TranslationServer.set_locale(locale)
