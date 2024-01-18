@tool
extends Popup

signal dialog_next()

@export var text_label : RichTextLabel
@export var char_name_label : Label


## apply current node data to UI
func apply_data(data):
	text_label.text = VNRunnerUtil.replace_vars_in_text(data.dialogue)
	char_name_label.text = data.character


func _on_next_button_pressed():
	hide()
	dialog_next.emit()
