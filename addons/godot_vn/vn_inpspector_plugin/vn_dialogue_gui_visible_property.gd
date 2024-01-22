@tool
class_name VnGuiDialogueProperty extends EditorProperty

var checkbox: CheckBox = CheckBox.new()

func _init():
	checkbox.text = "Switch On"
	checkbox.connect("toggled", was_checked)
	add_child(checkbox)

func was_checked(toggle):
	var obj : Node = get_edited_object()
	if !obj.dialogue_gui:
		obj.dialogue_gui = obj.get_node("VnDialogueGui")
	get_edited_object().dialogue_gui.visible = toggle
