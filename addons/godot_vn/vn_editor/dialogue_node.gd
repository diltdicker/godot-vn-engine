@tool
extends VnGraphNode

var dialogue_edit : TextEdit
var char_name_sel : OptionButton
var char_list = []

# popup nodes
var manage_char_popup : PopupPanel

signal  sync_character_list

func _enter_tree():
	node_id_label = find_child("NodeId")
	if (node_id_label == null):
		push_error("missing decendent 'NodeId'")
	else:
		node_id_label.text = name
	#start_id_edit = $HBoxContainer2/StartId
	
	manage_char_popup = $ManageCharPopup
	char_name_sel = $HBoxContainer/CharNameSelect
	dialogue_edit = $DialogueEdit

func import_data(data : Dictionary):
	name = data.id
	node_id_label.text = data.id
	position_offset = Vector2(data.position_offset[0], data.position_offset[1])
	position = Vector2(data.position[0], data.position[1])
	node_type = VnNodeType.get(data.node_type)
	char_name_sel.select(char_list.find(data.character))
	dialogue_edit.text = data.dialogue

func export() -> Dictionary:
	var character = ""
	if char_name_sel.item_count > 0:
		character = char_name_sel.get_item_text(char_name_sel.selected)
	return {
		"id": node_id_label.text,
		"position": [position.x, position.y],
		"position_offset": [position_offset.x, position_offset.y],
		"node_type": VnNodeType.keys()[node_type],
		"character" : character,
		"dialogue" : dialogue_edit.text,
		"connections" : []
	}


func _on_char_manage_button_pressed():
	manage_char_popup.popup_centered()
	manage_char_popup.size.x = 250
	#char_name_sel.selected = -1
	


func _on_manage_char_popup_popup_hide():
	char_list.clear()
	char_list = manage_char_popup.character_list.duplicate()
	char_name_sel.clear()
	char_name_sel.selected = -1
	for char_name in char_list:
		char_name_sel.add_item(char_name)
	sync_character_list.emit(char_list.duplicate())


func get_synced_chars(sync_list : Array):
	char_list = sync_list.duplicate(true)
	char_name_sel.clear()
	manage_char_popup.clear_char_list()
	char_name_sel.selected = -1
	for char_name in char_list:
		manage_char_popup.add_new_char(char_name)
		char_name_sel.add_item(char_name)
	
