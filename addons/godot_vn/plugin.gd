@tool
extends EditorPlugin

const VnGraphEditPanel = preload("res://addons/godot_vn/vn_editor/VnGraphEditor.tscn")
const green_icon : Texture2D = preload("res://addons/godot_vn/icons/godot_vn_green2.png")
const blue_icon : Texture2D = preload("res://addons/godot_vn/icons/godot_vn_blue.png")
const white_icon : Texture2D = preload("res://addons/godot_vn/icons/godot_vn_white.png")
const vn_runner : Script = preload("res://addons/godot_vn/vn_nodes/godot_vn_runner.gd")
const headless_runner : Script =  preload("res://addons/godot_vn/vn_nodes/headless_vn_runner.gd")

var vn_edit_panel_instance
var inspector_plugin


func _enter_tree():
	# inspector plugin
	inspector_plugin = VnGuiInpsector.new()
	add_inspector_plugin(inspector_plugin)
	
	#custom nodes
	add_custom_type("HeadlessVnRunner", "Node", headless_runner, blue_icon)
	add_custom_type("GodotVnRunner", "Control", vn_runner, green_icon)
	
	# Initialization of the plugin goes here.
	vn_edit_panel_instance = VnGraphEditPanel.instantiate()
	get_editor_interface().get_editor_main_screen().add_child(vn_edit_panel_instance)
	_make_visible(false)
	
	pass


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_custom_type("GodotVnRunner")
	remove_custom_type("HeadlessVnRunner")
	remove_inspector_plugin(inspector_plugin)
	
	
	
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
	return white_icon
