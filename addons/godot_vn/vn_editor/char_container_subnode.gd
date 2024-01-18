@tool
extends HBoxContainer

var name_edit : LineEdit
var label : Label
var char_index : int = -1

signal request_delete
signal name_changed

func _enter_tree():
	name_edit = $NameEdit
	label = $CharNumLabel

func set_char_index(num : int):
	label.text = str(num) + ":"
	char_index = num

func get_char_name() -> String:
	return name_edit.text
	
func set_char_name(name: String):
	name_edit.text = name

func replace_name_edit(replace_edit : LineEdit):
	name_edit.queue_free()
	name_edit = replace_edit
	add_child(name_edit)
	name_edit.connect("text_changed", _on_name_edit_text_changed)
	name_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL


func _on_name_edit_text_changed(new_text):
	if new_text == "":
		request_delete.emit(self)
	else:
		name_changed.emit(char_index, new_text)
