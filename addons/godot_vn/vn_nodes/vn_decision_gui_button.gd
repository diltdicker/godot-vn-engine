extends Button

signal choice_made(choice_text: String)

func on_button_pressed():
	choice_made.emit(text)
