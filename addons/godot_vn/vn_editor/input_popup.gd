@tool
extends Popup

signal recieved_input(input_key: String, input_value: String)

@export var user_q_label : Label
@export var user_a_edit : LineEdit

var key : String

## apply current node data to UI
func apply_data(data):
	user_a_edit.text = ""
	key = data.var_name
	user_q_label.text = data.user_input_q


func _on_line_edit_text_submitted(new_text):
	hide()
	recieved_input.emit(key, new_text)
