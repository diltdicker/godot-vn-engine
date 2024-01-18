@tool
class_name VNRunnerUtil

static var vn_map : VnGraphResource
static var db_table = {}

static func get_next_node(cur_node: Dictionary, port : int = 0) -> Dictionary:
	var next_node = null
	
	for conn in cur_node.connections:
		if conn.from_port == port:
			next_node = get_node_dict(conn.to_node)
			break
	
	return next_node


static func get_node_dict(cur_id: String) -> Dictionary:
	if !vn_map:
		push_error("vn_map is NULL")
	
	# check graph nodes
	var graph_node = vn_map.vn_data_graph[cur_id]
	if graph_node:
		return graph_node
	
	# check start nodes
	for start_node in vn_map.vn_start_nodes:
		if cur_id == start_node.id:
			return start_node
	
	push_error("unable to find node [%s] in resource graph", cur_id)
	var null_dict : Dictionary
	return null_dict


static func apply_variable_node(cur_node: Dictionary) -> void:
	var old_val = db_table.get(cur_node.var_name)
	var op_int = VnVariableNode.var_operation.keys().find(cur_node.var_op)
		
	if op_int == VnVariableNode.var_operation.SET:
		db_table[cur_node.var_name] = cur_node.var_value
		
	elif op_int == VnVariableNode.var_operation.ADD: 
		db_table[cur_node.var_name] += cur_node.var_value
	
	elif op_int == VnVariableNode.var_operation.SUB: 
		db_table[cur_node.var_name] -= cur_node.var_value
	
	elif op_int == VnVariableNode.var_operation.MUL: 
		db_table[cur_node.var_name] *= cur_node.var_value
	
	elif op_int == VnVariableNode.var_operation.DIV: 
		db_table[cur_node.var_name] /= cur_node.var_value
		
	print("apply varaible %s, key: [%s], old-val: [%s], new-val: [%s]" % [cur_node.var_op, cur_node.var_name, 
	str(old_val), str(db_table[cur_node.var_name])])

static func determine_condition_next_node(cur_node: Dictionary) -> Dictionary:
	if !db_table.get(cur_node.var_name):
		push_error("unable to find [%s] variable in db_table: [%s]" % [cur_node.var_type, cur_node.var_name])
	
	var v_type = VnConditionNode.var_type.keys().find(cur_node.var_type)
	var logic = VnConditionNode.operations.keys().find(cur_node.logic)
	var result
	
	if logic == VnConditionNode.operations.EQUALS:
		result = cur_node.var_value == db_table[cur_node.var_name]
	
	elif logic == VnConditionNode.operations.NOT_EQUAL_TO:
		result = cur_node.var_value != db_table[cur_node.var_name]
		
	elif logic == VnConditionNode.operations.LESS_THAN:
		result = db_table[cur_node.var_name] < cur_node.var_value
	
	elif logic == VnConditionNode.operations.LESS_THAN_EQUALS:
		result = db_table[cur_node.var_name] <= cur_node.var_value
	
	elif logic == VnConditionNode.operations.GREATER_THAN:
		result = db_table[cur_node.var_name] > cur_node.var_value
	
	elif logic == VnConditionNode.operations.GREATER_THAN_EQUALS:
		result = db_table[cur_node.var_name] >= cur_node.var_value
	
	if result:
		return get_next_node(cur_node, 0)
	else:
		return get_next_node(cur_node, 1)


## replaces text with values from table_db:
## use the ${var_name} format
static func replace_vars_in_text(dialogue: String) -> String:
	var mod_str = dialogue
	var regex = RegEx.new()
	regex.compile("(\\$\\{(\\w+)\\})")
	for result in regex.search_all(mod_str):
		var to_replace = result.get_string(1)
		var replace_str = str(db_table.get(result.get_string(2)))
		mod_str = mod_str.replace(to_replace, replace_str)
	return mod_str
