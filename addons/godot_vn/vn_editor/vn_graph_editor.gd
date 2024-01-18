@tool
extends GraphEdit

@export var exportMenu : FileDialog = null
@export var loadMenu : FileDialog = null

# signals
signal start_debug(start_id: String, vn_graph: VnGraphResource)
signal sync_character_list(cahr_list: Array)

const start_node_pckd = preload("res://addons/godot_vn/vn_editor/StartNode.tscn")
const dialg_node_pckd = preload("res://addons/godot_vn/vn_editor/DialogueNode.tscn")
const input_node_pckd = preload("res://addons/godot_vn/vn_editor/InputNode.tscn")
const decsn_node_pckd = preload("res://addons/godot_vn/vn_editor/DecisionNode.tscn")
const varbl_node_pckd = preload("res://addons/godot_vn/vn_editor/VariableNode.tscn")
const condi_node_pckd = preload("res://addons/godot_vn/vn_editor/ConditionNode.tscn")
const signl_node_pckd = preload("res://addons/godot_vn/vn_editor/SignalNode.tscn")
const notes_node_pckd = preload("res://addons/godot_vn/vn_editor/NotesNode.tscn")
const  end_node_pcked = preload("res://addons/godot_vn/vn_editor/EndNode.tscn")
const goto_node_pcked = preload("res://addons/godot_vn/vn_editor/GotoNode.tscn")

# clipboard for copy / pasting nodes
var clipboard = []

# selection array for node deletion
var curSelection = {}

# character list
var character_list = []

func spawn_start_node():
	var spawn_node : VnGraphNode = start_node_pckd.instantiate()
	spawn_node.set_hex_id(PluginUtils.gen_uinque_hexideci())
	spawn_node.position_offset = scroll_offset + Vector2(100, 100)
	spawn_node.connect("run_debug", handle_debug_run_start)
	add_child(spawn_node)
	return spawn_node


func _on_node_start_button_pressed():
	spawn_start_node()
	

# recieve request when a dialogue nodes list of characters
# is updated. Then emit a signal to all dialogue nodes for 
# the updated list
func handle_sync_chars(char_list : Array):
	character_list = char_list.duplicate(true)
	sync_character_list.emit(character_list)


func spawn_dialogue_node():
	var spawn_node : VnGraphNode = dialg_node_pckd.instantiate()
	spawn_node.set_hex_id(PluginUtils.gen_uinque_hexideci())
	spawn_node.position_offset = scroll_offset + Vector2(120, 100)
	add_child(spawn_node)
	spawn_node.get_synced_chars(character_list)
	spawn_node.connect("sync_character_list", handle_sync_chars)
	connect("sync_character_list", spawn_node.get_synced_chars)
	return spawn_node

func _on_node_dialogue_button_pressed():
	spawn_dialogue_node()


func spawn_input_node():
	var spawn_node : VnGraphNode = input_node_pckd.instantiate()
	spawn_node.set_hex_id(PluginUtils.gen_uinque_hexideci())
	spawn_node.position_offset = scroll_offset + Vector2(140, 100)
	add_child(spawn_node)
	return spawn_node
	

func _on_node_input_button_pressed():
	spawn_input_node()


func spawn_decision_node():
	var spawn_node : VnGraphNode = decsn_node_pckd.instantiate()
	spawn_node.set_hex_id(PluginUtils.gen_uinque_hexideci())
	spawn_node.position_offset = scroll_offset + Vector2(160, 100)
	spawn_node.connect("delete_decision_port", handle_decision_port_delete)
	add_child(spawn_node)
	return spawn_node

func _on_node_decision_button_pressed():
	spawn_decision_node()

func handle_decision_port_delete(id: String, port: int):
	var rearange_conns = []
	# delete conn and collect any ports that are of higher num
	for conn in get_connection_list():
		if conn.from_node == id && conn.from_port == port:
			disconnect_node( conn.from_node, conn.from_port, conn.to_node, conn.to_port)
		elif conn.from_node == id && conn.from_port > port:
			rearange_conns.append(conn)
	# move ports of higher num down 1 so that they preserve conns
	for conn in rearange_conns:
		disconnect_node( conn.from_node, conn.from_port, conn.to_node, conn.to_port)
		connect_node( conn.from_node, conn.from_port - 1, conn.to_node, conn.to_port)


func spawn_variable_node():
	var spawn_node : VnGraphNode = varbl_node_pckd.instantiate()
	spawn_node.set_hex_id(PluginUtils.gen_uinque_hexideci())
	spawn_node.position_offset = scroll_offset + Vector2(180, 100)
	add_child(spawn_node)
	return spawn_node


func _on_node_variable_button_pressed():
	spawn_variable_node()


func spawn_condition_node():
	var spawn_node : VnGraphNode = condi_node_pckd.instantiate()
	spawn_node.set_hex_id(PluginUtils.gen_uinque_hexideci())
	spawn_node.position_offset = scroll_offset + Vector2(200, 100)
	add_child(spawn_node)
	return spawn_node


func _on_node_condition_button_pressed():
	spawn_condition_node()


func spawn_signal_node():
	var spawn_node : VnGraphNode = signl_node_pckd.instantiate()
	spawn_node.set_hex_id(PluginUtils.gen_uinque_hexideci())
	spawn_node.position_offset = scroll_offset + Vector2(220, 100)
	add_child(spawn_node)
	return spawn_node


func _on_node_signal_button_pressed():
	spawn_signal_node()


func spawn_goto_node():
	var spawn_node : VnGraphNode = goto_node_pcked.instantiate()
	spawn_node.set_hex_id(PluginUtils.gen_uinque_hexideci())
	spawn_node.position_offset = scroll_offset + Vector2(240, 100)
	add_child(spawn_node)
	return spawn_node


func _on_node_goto_button_pressed():
	spawn_goto_node()


func spawn_notes_node():
	var spawn_node : VnGraphNode = notes_node_pckd.instantiate()
	spawn_node.set_hex_id(PluginUtils.gen_uinque_hexideci())
	spawn_node.position_offset = scroll_offset + Vector2(260, 100)
	add_child(spawn_node)
	return spawn_node


func _on_node_notes_button_pressed():
	spawn_notes_node()


func spawn_end_node():
	var spawn_node : VnGraphNode = end_node_pcked.instantiate()
	spawn_node.set_hex_id(PluginUtils.gen_uinque_hexideci())
	spawn_node.position_offset = scroll_offset + Vector2(280, 100)
	add_child(spawn_node)
	return spawn_node


func _on_node_end_button_pressed():
	spawn_end_node()


func _on_reset_button_pressed():
	# delete all connections
	for conn in get_connection_list():
		disconnect_node(conn.from_node, conn.from_port, conn.to_node, conn.to_port)
	
	# delete all children
	for del_node : Node in get_children():
		del_node.queue_free()
	
	# clear selection
	curSelection.clear()
	
	# clear character list
	character_list.clear()


func get_all_from_conns(node_id: String) -> Array:
	var conns = []
	for conn in  get_connection_list():
		if conn.from_node == node_id:
			conns.append(conn)
	return conns


func _on_export_button_pressed():
	#exportMenu.filters = GDVNFormatSaver.formats
	if exportMenu:
		exportMenu.popup()


func _on_load_button_pressed():
	if loadMenu:
		loadMenu.popup()
		


func _on_delete_nodes_request(nodes):
	var selected_ids = curSelection.keys()
	
	# iterate through and delete all connections with selected nodes
	for conn in get_connection_list():
		if conn.to_node in selected_ids || conn.from_node in selected_ids:
			disconnect_node(conn.from_node, conn.from_port, 
				conn.to_node, conn.to_port)
	
	# remove selected nodes from scene
	for sel_node : Node in curSelection.values():
		sel_node.queue_free()
		curSelection.erase(sel_node.get_hex_id())
		

func _on_disconnection_request(from_node, from_port, to_node, to_port):
	disconnect_node(from_node, from_port, to_node, to_port)


func _on_connection_request(from_node, from_port, to_node, to_port):
	if from_node == to_node:
		push_warning("trying to make graph connection to same node is not allowed")
		return
	for connection in get_connection_list():
		# allow connections such that nodes can only have one optput per port
		if connection.from_node == from_node and connection.from_port == from_port:
			# disconnect previous
			disconnect_node(connection.from_node, connection.from_port, 
				connection.to_node, connection.to_port)
			break
	connect_node(from_node, from_port, to_node, to_port)


func _on_copy_nodes_request():
	clipboard = curSelection.values()


func _on_paste_nodes_request():
	# deselect all nodes
	for sel_node : GraphNode in curSelection.values():
		sel_node.selected = false
	curSelection.clear()
	
	# copy nodes to tree and set selected
	for clip_node : GraphNode in clipboard:
		var copy_node : GraphNode 
		
		# alt copy paste logic
		if clip_node.node_type in [VnGraphNode.VnNodeType.DIALOGUE,
		VnGraphNode.VnNodeType.DECISION, VnGraphNode.VnNodeType.CONDITION,
		VnGraphNode.VnNodeType.VARIABLE, VnGraphNode.VnNodeType.START]:
			var export_copy : Dictionary
			var id_hold : String
			if clip_node.node_type == VnGraphNode.VnNodeType.DIALOGUE:
				copy_node = spawn_dialogue_node()
			elif clip_node.node_type == VnGraphNode.VnNodeType.DECISION:
				copy_node = spawn_decision_node()
			elif clip_node.node_type == VnGraphNode.VnNodeType.CONDITION:
				copy_node = spawn_condition_node()
			elif clip_node.node_type == VnGraphNode.VnNodeType.VARIABLE:
				copy_node = spawn_variable_node()
			elif clip_node.node_type == VnGraphNode.VnNodeType.START:
				copy_node = spawn_start_node()
			else:
				continue
				
			id_hold = copy_node.get_hex_id()
			export_copy = clip_node.export()
			copy_node.import_data(export_copy)
			copy_node.set_hex_id(id_hold)
			copy_node.selected = true
			curSelection[id_hold] = copy_node
			copy_node.position_offset += Vector2(25, 25)
			
		else:
			copy_node = clip_node.duplicate()
			copy_node.selected = true
			copy_node.position_offset += Vector2(25, 25)
			var id = PluginUtils.gen_uinque_hexideci()
			copy_node.set_hex_id(id)
			curSelection[id] = copy_node
			add_child(copy_node)
	
	# update clipboard to current selected
	clipboard = curSelection.values()


func _on_node_deselected(node):
	if curSelection.has(node.get_hex_id()):
		curSelection.erase(node.get_hex_id())


func _on_node_selected(node):
	if !curSelection.has(node.get_hex_id()):
		curSelection[node.get_hex_id()] = node


func _on_open_dialog_file_selected(load_path):
	var conn_list = []
	_on_reset_button_pressed()
	var load_file : VnGraphResource = ResourceLoader.load(load_path)
	character_list = load_file.vn_character_list.duplicate(true)
	
	for start_node in load_file.vn_start_nodes:
		conn_list += start_node.connections
		var load_node = spawn_start_node()
		load_node.import_data(start_node)
		
	#print("all nodes:")
	for node_dict in load_file.vn_data_graph.values():
		conn_list += node_dict.connections
		var load_node = null
		var node_type_int =  VnGraphNode.VnNodeType.keys().find(node_dict.node_type)
		if node_type_int == VnGraphNode.VnNodeType.DIALOGUE:
			load_node = spawn_dialogue_node()
		elif node_type_int == VnGraphNode.VnNodeType.CONDITION:
			load_node = spawn_condition_node()
		elif node_type_int == VnGraphNode.VnNodeType.DECISION:
			load_node = spawn_decision_node()
		elif node_type_int == VnGraphNode.VnNodeType.END:
			load_node = spawn_end_node()
		elif node_type_int == VnGraphNode.VnNodeType.GOTO:
			load_node = spawn_goto_node()
		elif node_type_int == VnGraphNode.VnNodeType.INPUT:
			load_node = spawn_input_node()
		elif node_type_int == VnGraphNode.VnNodeType.NOTES:
			load_node = spawn_notes_node()
		elif node_type_int == VnGraphNode.VnNodeType.SIGNAL:
			load_node = spawn_signal_node()
		elif node_type_int == VnGraphNode.VnNodeType.VARIABLE:
			load_node = spawn_variable_node()
		if load_node:
			load_node.import_data(node_dict)
	
	# add connections
	for conn in conn_list:
		connect_node(conn.from_node, conn.from_port, conn.to_node, conn.to_port)


func collect_export_data() -> VnGraphResource:
	var start_str = VnGraphNode.VnNodeType.keys()[VnGraphNode.VnNodeType.START]
	var save_file = VnGraphResource.new()
	save_file.vn_character_list = character_list.duplicate(true)
	
	for node_child in get_children():
		var export_data = node_child.export()
		if export_data:
			# saves all the connections under the 'from_node'
			export_data.connections = get_all_from_conns(export_data.id)
			if (export_data.node_type == start_str):
				save_file.vn_start_nodes.append(export_data)
			else:
				save_file.vn_data_graph[export_data.id] = export_data
	return save_file


func handle_debug_run_start(start_id):
	start_debug.emit(start_id, collect_export_data())


func _on_export_dialog_file_selected(save_path):
	ResourceSaver.save(collect_export_data(), save_path)
