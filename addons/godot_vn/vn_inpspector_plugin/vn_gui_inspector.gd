@tool
class_name VnGuiInpsector extends EditorInspectorPlugin

const gdvn_runner_script : Script = preload("res://addons/godot_vn/vn_nodes/godot_vn_runner.gd")

func _can_handle(object):
	#return object is GodotVnRunner
	return object.get_script() == gdvn_runner_script

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	if name == "make_dialogue_visible":
		# button to apply style changes
		var bttn = Button.new()
		bttn.connect("pressed", object.apply_style_changes)
		bttn.text = "Apply Style Changes"
		add_custom_control(bttn)
		# added checkbox for viewing VN preview
		add_property_editor(name, VnGuiDialogueProperty.new())
		return true
	if name == "make_decision_visible":
		add_property_editor(name, VnGuiDecisionProperty.new())
		return true
	if name == "make_input_visible":
		add_property_editor(name, VnGuiInputProperty.new())
		return true
		
	
