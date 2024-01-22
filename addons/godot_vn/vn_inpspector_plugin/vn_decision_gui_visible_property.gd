@tool
class_name VnGuiDecisionProperty extends EditorProperty

var checkbox: CheckBox = CheckBox.new()

func _init():
	checkbox.text = "Switch On"
	checkbox.connect("toggled", was_checked)
	add_child(checkbox)

func was_checked(toggle):
	var obj : Node = get_edited_object()
	if !obj.decision_gui:
		obj.decision_gui = obj.get_node("VnDialogueGui")
	get_edited_object().decision_gui.visible = toggle
