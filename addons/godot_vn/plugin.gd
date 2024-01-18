@tool
extends EditorPlugin

const VnGraphEditPanel = preload("res://addons/godot_vn/vn_editor/VnGraphEditor.tscn")
var vn_edit_panel_instance

func _enter_tree():
	# Initialization of the plugin goes here.
	vn_edit_panel_instance = VnGraphEditPanel.instantiate()
	
	get_editor_interface().get_editor_main_screen().add_child(vn_edit_panel_instance)
	_make_visible(false)
	
	const CustPanel : PackedScene = preload("res://addons/godot_vn/nodes/cust_panel.tscn")
	#pass
	add_custom_type("ExampleButton", "Button", preload("res://addons/godot_vn/nodes/example_button.gd"),
		preload("res://icon.svg"))
	add_custom_type("AboveCharVNBox", "TextureRect", preload("res://addons/godot_vn/nodes/char_abv_vn_box.gd"), preload("res://icon.svg"))
	pass


func _exit_tree():
	# Clean-up of the plugin goes here.
	#pass
	remove_custom_type("ExampleButton")
	remove_custom_type("AboveCharVNBox")
	
	if vn_edit_panel_instance:
		vn_edit_panel_instance.queue_free()
	pass

func _has_main_screen():
	return true


func _make_visible(visible):
	if vn_edit_panel_instance:
		vn_edit_panel_instance.visible = visible


func _get_plugin_name():
	return "GodotVN"


func _get_plugin_icon():
	return null
