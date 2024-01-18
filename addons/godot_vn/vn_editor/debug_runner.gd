@tool
extends Node



@export var dialog_popup : Popup
@export var decision_popup : Popup
@export var input_popup : Popup

var cur_node : Dictionary

func _on_graph_edit_start_debug(start_id, vn_graph):
	hide_all()
	VNRunnerUtil.vn_map = null
	VNRunnerUtil.vn_map = vn_graph
	VNRunnerUtil.db_table.clear()
	#cur_node = start_id
	for s_node in VNRunnerUtil.vn_map.vn_start_nodes:
		if s_node.id == start_id:
			cur_node = s_node
			break
	print("START with param [%s]" % cur_node.start_param)
	cur_node = VNRunnerUtil.get_next_node(cur_node)
	handle_next_node(cur_node)

func hide_all():
	dialog_popup.visible = false
	decision_popup.visible = false
	input_popup.visible = false

func handle_next_node(vn_node: Dictionary):
	if !vn_node || vn_node == {}:
		push_error("unable to handle null next_node")
		hide_all()
		return
		
	var vn_node_type_int = VnGraphNode.VnNodeType.keys().find(vn_node.node_type)
	match vn_node_type_int:
		
		VnGraphNode.VnNodeType.DIALOGUE:
			dialog_popup.apply_data(vn_node)
			dialog_popup.popup()
			decision_popup.visible = false
			input_popup.visible = false
			
		VnGraphNode.VnNodeType.DECISION:
			decision_popup.apply_data(vn_node)
			dialog_popup.visible = false
			decision_popup.popup()
			input_popup.visible = false
			
		VnGraphNode.VnNodeType.CONDITION:
			cur_node = VNRunnerUtil.determine_condition_next_node(cur_node)
			handle_next_node(cur_node)
			
		VnGraphNode.VnNodeType.VARIABLE:
			VNRunnerUtil.apply_variable_node(cur_node)
			cur_node = VNRunnerUtil.get_next_node(cur_node)
			handle_next_node(cur_node)
			
		VnGraphNode.VnNodeType.INPUT:
			input_popup.apply_data(vn_node)
			dialog_popup.visible = false
			decision_popup.visible = false
			input_popup.popup()
			
		VnGraphNode.VnNodeType.SIGNAL:
			print("emitted signal with param [%s]" % vn_node.signal_param)
			cur_node = VNRunnerUtil.get_next_node(cur_node)
			handle_next_node(cur_node)
			
		VnGraphNode.VnNodeType.GOTO:
			cur_node = VNRunnerUtil.get_node_dict(vn_node.goto_node)
			handle_next_node(cur_node)
			
		VnGraphNode.VnNodeType.END:
			print("END of VN with param [%s]" % vn_node.end_param)
			hide_all()
			
		_:
			push_error("unkown node type [%s] for node [%s]" % [vn_node.node_type, vn_node.id])


func _on_dialog_pop_up_dialog_next():
	cur_node = VNRunnerUtil.get_next_node(cur_node)
	handle_next_node(cur_node)


func _on_decsion_pop_up_decision_made(port):
	cur_node = VNRunnerUtil.get_next_node(cur_node, port)
	handle_next_node(cur_node)


func _on_input_pop_up_recieved_input(input_key, input_value):
	VNRunnerUtil.db_table[input_key] = input_value
	print("set variable, key: [%s], val: [%s]" %  [input_key, input_value])
	cur_node = VNRunnerUtil.get_next_node(cur_node)
	handle_next_node(cur_node)
