@tool
extends PopupPanel

var character_list = []
var timer_new_char : Timer
var vbox_container : VBoxContainer
var new_char_edit : LineEdit
var character_node_list = []
const pckd_char_container = preload("res://addons/godot_vn/vn_editor/CharContainerSubNode.tscn")


func _enter_tree():
	timer_new_char = $NewCharTimer
	vbox_container = $PanelContainer/ScrollContainer/VBoxContainer
	new_char_edit = $PanelContainer/ScrollContainer/VBoxContainer/NewCharEdit


func add_new_char(name : String):
	var copy_char = pckd_char_container.instantiate()
	vbox_container.add_child(copy_char)
	copy_char.connect("request_delete", handle_char_delete_request)
	copy_char.connect("name_changed", handle_char_name_change)
	copy_char.set_char_name(name)
	copy_char.set_char_index(character_list.size())
	vbox_container.move_child(new_char_edit, vbox_container.get_child_count() - 1)
	character_node_list.append(copy_char)
	character_list.append(name)
	
func handle_char_name_change(index: int, char_name: String):
	character_list[index] = char_name

func fix_list_nums():
	# correct list numbers
	for i in range(character_node_list.size()):
		character_node_list[i].set_char_index(i)

func clear_char_list():
	character_list = []
	for node in character_node_list:
		node.queue_free()
	character_node_list = []

func handle_char_delete_request(node : Node):
	var del_loc = node.char_index
	character_node_list.remove_at(del_loc)
	character_list.remove_at(del_loc)
	node.queue_free()
	fix_list_nums()


func _on_new_char_edit_text_changed(new_text):
	timer_new_char.start()


func _on_new_char_timer_timeout():
	add_new_char(new_char_edit.text)
	new_char_edit.text = ""

