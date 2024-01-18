@tool
class_name VnVariableNode extends VnGraphNode

var var_op_bttn : OptionButton
var var_type_bttn : OptionButton
var var_name_edit : LineEdit
var var_set_label : Label
var var_mod_label : Label
var bool_option : OptionButton
var num_edit : SpinBox
var str_edit : LineEdit

enum var_operation {SET, ADD, SUB, MUL, DIV}

enum var_type {INT, BOOL, STRING}

func _enter_tree():
	node_id_label = find_child("NodeId")
	if (node_id_label == null):
		push_error("missing decendent 'NodeId'")
	else:
		node_id_label.text = name
	var_op_bttn = $HBoxContainer4/VarOpButton
	var_type_bttn = $HBoxContainer3/VarTypeButton
	var_name_edit = $HBoxContainer2/HBoxContainer/VarName
	var_set_label = $HSplitContainer/HBoxContainer2/SetLabel
	var_mod_label = $HSplitContainer/HBoxContainer2/ModLabel
	bool_option = $HSplitContainer/HBoxContainer/BoolOption
	num_edit = $HSplitContainer/HBoxContainer/NumEdit
	str_edit = $HSplitContainer/HBoxContainer/StringEdit


func import_data(data : Dictionary):
	name = data.id
	node_id_label.text = data.id
	position_offset = Vector2(data.position_offset[0], data.position_offset[1])
	position = Vector2(data.position[0], data.position[1])
	node_type = VnNodeType.get(data.node_type)
	
	_on_var_type_button_item_selected(var_type.keys().find(data.var_type))
	var_type_bttn.select(var_type.keys().find(data.var_type))
	_on_var_op_button_item_selected(var_operation.keys().find(data.var_op))
	var_op_bttn.select(var_operation.keys().find(data.var_op))
	
	var type_int = var_type.keys().find(data.var_type)
	
	if (type_int == var_type.BOOL):
		bool_option.select(int(data.var_value))
		
	elif (type_int == var_type.INT):
		num_edit.value = int(data.var_value)
		
	elif (type_int == var_type.STRING):
		str_edit.text = data.var_value
		
	var_name_edit.text = data.var_name


func export() -> Dictionary:
	var var_value = null
	if (var_type_bttn.selected == var_type.BOOL):
		var_value = bool_option.selected == 1
	elif (var_type_bttn.selected == var_type.INT):
		var_value = int(num_edit.value)
	elif (var_type_bttn.selected == var_type.STRING):
		var_value = str_edit.text
	return {
		"id": node_id_label.text,
		"position": [position.x, position.y],
		"position_offset": [position_offset.x, position_offset.y],
		"node_type": VnNodeType.keys()[node_type],
		"var_name": var_name_edit.text,
		"var_type": var_type.keys()[var_type_bttn.selected],
		"var_op" : var_operation.keys()[var_op_bttn.selected],
		"var_value": var_value,
		"connections" : []
	}


func _on_var_type_button_item_selected(index):
	if ( index == var_type.BOOL || index == var_type.STRING):
		var_op_bttn.select(var_operation.SET)
		var_set_label.visible = true
		var_mod_label.visible = false
		
		# disable mod options
		for op in var_operation.values():
			if op != var_operation.SET:
				var_op_bttn.set_item_disabled(op, true)
		
		if (index == var_type.BOOL):
			num_edit.visible = false
			str_edit.visible = false
			bool_option.visible = true
		else:
			num_edit.visible = false
			str_edit.visible = true
			bool_option.visible = false
		
	else:
		# enable mod options
		for op in var_operation.values():
			var_op_bttn.set_item_disabled(op, false)
		num_edit.visible = true
		str_edit.visible = false
		bool_option.visible = false


func _on_var_op_button_item_selected(index):
	if (var_operation.get(index) == var_operation.SET):
		var_set_label.visible = true
		var_mod_label.visible = false
	else:
		var_set_label.visible = false
		var_mod_label.visible = true
