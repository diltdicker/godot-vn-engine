@tool
class_name VnConditionNode extends VnGraphNode

var var_type_sel : OptionButton
var var_name_edit : LineEdit
var var_str_edit : LineEdit
var var_int_edit : SpinBox
var var_bool_sel : OptionButton
var logic_button : OptionButton

enum operations {EQUALS, NOT_EQUAL_TO, LESS_THAN, LESS_THAN_EQUALS, GREATER_THAN, GREATER_THAN_EQUALS}

enum var_type {INT, BOOL, STRING}


func _enter_tree():
	node_id_label = find_child("NodeId")
	if (node_id_label == null):
		push_error("missing decendent 'NodeId'")
	else:
		node_id_label.text = name
	var_name_edit = $HBoxContainer2/VarNameEdit
	var_str_edit = $HBoxContainer5/StrValueEdit
	logic_button = $HBoxContainer4/HBoxContainer/LogicButton
	var_int_edit = $HBoxContainer5/IntValEdit
	var_bool_sel = $HBoxContainer5/BoolValSelect
	var_type_sel = $HBoxContainer5/VarTypeSelect
	

func import_data(data : Dictionary):
	name = data.id
	node_id_label.text = data.id
	position_offset = Vector2(data.position_offset[0], data.position_offset[1])
	position = Vector2(data.position[0], data.position[1])
	node_type = VnNodeType.get(data.node_type)
	var_name_edit.text = data.var_name
	var var_type_idx = var_type.keys().find(data.var_type)
	if var_type_idx == var_type.BOOL:
		set_var_bool()
		var_bool_sel.select(int(data.var_value))
	elif var_type_idx == var_type.INT:
		set_var_int()
		var_int_edit.value = int(data.var_value)
	elif var_type_idx == var_type.STRING:
		set_var_str()
		var_str_edit.text = str(data.var_value)
	logic_button.select(operations.keys().find(data.logic))
	


func export() -> Dictionary:
	var var_value = ""
	if var_type_sel.selected == var_type.BOOL:
		var_value = 1 == var_bool_sel.selected
	elif var_type_sel.selected == var_type.INT:
		var_value = var_int_edit.value
	elif var_type_sel.selected == var_type.STRING:
		var_value = var_str_edit.text
	return {
		"id": node_id_label.text,
		"position": [position.x, position.y],
		"position_offset": [position_offset.x, position_offset.y],
		"node_type": VnNodeType.keys()[node_type],
		"var_name" : var_name_edit.text,
		"var_type": var_type.keys()[var_type_sel.selected],
		"var_value": var_value,
		"logic": operations.keys()[logic_button.selected],
		"connections" : []
	}

func set_var_int():
	for i in range(operations.values().size()):
		logic_button.set_item_disabled(i, false)
		var_bool_sel.visible = false
		var_int_edit.visible = true
		var_str_edit.visible = false

func set_var_str():
	for i in range(operations.values().size()):
		if i < 2:
			logic_button.set_item_disabled(i, false)
		else :
			logic_button.set_item_disabled(i, true)
		var_bool_sel.visible = false
		var_int_edit.visible = false
		var_str_edit.visible = true
		logic_button.select(0)


func set_var_bool():
	for i in range(operations.values().size()):
		if i < 2:
			logic_button.set_item_disabled(i, false)
		else :
			logic_button.set_item_disabled(i, true)
		var_bool_sel.visible = true
		var_int_edit.visible = false
		var_str_edit.visible = false
		logic_button.select(0)


func _on_var_type_select_item_selected(index):
	if index == var_type.BOOL:
		set_var_bool()
	elif index == var_type.INT:
		set_var_int()
	elif index == var_type.STRING:
		set_var_str()
