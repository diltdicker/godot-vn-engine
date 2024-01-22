@tool
class_name VnInputGui extends CenterContainer

var input_edit : LineEdit
var input_label : Label
var input_callback : Callable

func _enter_tree():
	input_edit = $PanelContainer/MarginContainer/VBoxContainer/LineEdit
	input_label = $PanelContainer/MarginContainer/VBoxContainer/Label

func display_input_question(question: String, callback):
	input_callback = callback
	input_label.text = question
	input_edit.clear()


func _on_line_edit_text_submitted(new_text):
	print("input", new_text)
	input_callback.call(new_text)
