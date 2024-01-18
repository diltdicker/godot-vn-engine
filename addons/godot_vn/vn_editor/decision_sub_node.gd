@tool
class_name DecisionSubNode extends HBoxContainer

var decison_id_label : Label
var decision_text : LineEdit
var delete_bttn : Button
var decison_id : int = -1

signal request_decision_delete

func  _enter_tree():
	decison_id_label = $DecisionId
	decision_text = $DecisionText
	setup_decision_button()

func setup_decision_button():
	decision_text.expand_to_text_length = true
	decision_text.clear_button_enabled = true
	decision_text.caret_blink = true
	decision_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	decision_text.connect("text_changed", check_del_request)

func replace_decision_text(text_edit: LineEdit):
	if decision_text:
		decision_text.queue_free()
	decision_text = text_edit
	add_child(text_edit)
	move_child(text_edit, 1)
	setup_decision_button()

func set_id(id : int):
	decison_id_label.text = str(id)+" : "
	decison_id = id

func get_id():
	return decison_id

func set_text(text : String):
	decision_text.text = text

func get_text():
	return decision_text.text

func check_del_request(some_text):
	if decision_text.text.length() == 0:
		request_decision_delete.emit(decison_id)
