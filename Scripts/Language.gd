extends Button

func _on_Language_button_up():
	TranslationServer.set_locale("es")
	Global.font.size = 100
	pass # Replace with function body.
