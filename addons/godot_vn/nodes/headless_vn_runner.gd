class_name HeadlessVNRunner extends Node

## Visual novel graph file containing dilogue, events, variables etc... (create using GodotVN editor)
@export var godot_vn_file : VnGraphResource
## Start param for which start node to enter VN graph (not needed if only 1 start node)
@export var default_start_param : String = ""
## Begins emitting signals from VN upon _ready()
@export var start_on_ready: bool = false

## Current node in the VN graph
var current_node : Dictionary
## Hexid of current node in VN graph (useful for if you want to save game in the middle of graph)
var current_id : String
## List of ids of previously seen dialogues (useful for if you want to implement skip functionality to your game)
var seen_dialogues : Array[String] = []

## Signal emitted from signal node in VN graph
signal vn_trigger_signaled(param: String)

## Signal that a Character (char_name) is speaking (dialogue_text).
## next_callback is used for requesting the next node in VN graph (triggering next signal).
## next_callback is called using the .call() method: next_callback.call()
signal dialogue_reached(char_name: String, dialogue_text: String, next_callback: Callable)

## VN graph reached an end node (useful for when to switch from VN mode to gameplay)
signal vn_ended(param: String)

## Signal that a decision node has been reached and provides availible choices.
## decision_callback is used for requesting the next node in VN graph (triggering next signal).
## decision_callback is called using the .call() method: decision_callback.call(decision: int)
signal decision_reached(choices: Array[String], decision_callback: Callable)

## Signal that an input node is requesting user input.
## Singal uses answer_callback for storing the user's input into the VN's db_table.
## answer_callback is used for requesting the next node in VN graph (triggering next signal).
## answer_callback is called using the .call() method: answer_callback.call(input_txt: String)
signal input_requested(question_text: String, answer_callback: Callable)

## Triggers runner to start progressing through VN grpah.
## Searchs VN graph start nodes for node with matching param.
## Upon starting, runner will begin emitting signals: [vn_trigger_signaled, dialogue_reached,
## vn_ended, decision_reached, input_requested] as it progresses through VN graph.
func vn_start(param: String):
	_load_vn_file()
	if VNRunnerUtil.vn_map.vn_start_nodes.size() == 1:
		current_node = VNRunnerUtil.vn_map.vn_start_nodes[0]
	else:
		for s_node in VNRunnerUtil.vn_map.vn_start_nodes:
			if s_node.id == param:
				current_node = s_node
				break
	if !current_node:
		push_error("unable to find start node with matching param [%s]" % param)
		return
	_update_current_node(VNRunnerUtil.get_next_node(current_node))
	_handle_next_node(current_node)


## Triggers runner to start progressing through VN grpah. 
## Imediately skips to provided node_id and begins there. (useful if loading a saved game).
## Upon starting, runner will begin emitting signals: [vn_trigger_signaled, dialogue_reached,
## vn_ended, decision_reached, input_requested] as it progresses through VN graph.
func vn_skip(node_id: String):
	_load_vn_file()
	_update_current_node(VNRunnerUtil.get_node_dict(node_id))
	_handle_next_node(current_node)


## Export db_table dictionary that holds VN variables (useful for saving game)
func db_table_export() -> Dictionary:
	return VNRunnerUtil.db_table.duplicate(true) 

## Import db_table dictionary that holds VN variables (useful for loading a saved game)
func db_table_import(dict: Dictionary) -> void:
	VNRunnerUtil.db_table.merge(dict, true)

## Manually set a variable in VN db_table
func db_table_store(key: String, value) -> void:
	VNRunnerUtil.db_table[key] = value

## Retrieve a variable from the VN db_table
func db_table_get(key: String):
	return VNRunnerUtil.db_table.get(key)

## Clears the VN db_table
func db_table_clear():
	VNRunnerUtil.db_table.clear()


func _ready():
	if start_on_ready:
		vn_start(default_start_param)


func _load_vn_file():
	if !godot_vn_file:
		push_error("Missing .gdvn.tres file for Visual Novel traversal")
		return
	if godot_vn_file.vn_start_nodes == []:
		push_error("Godot Visual novel file has no start nodes")
		return
	VNRunnerUtil.vn_map = null
	VNRunnerUtil.vn_map = godot_vn_file

func _update_current_node(vn_node: Dictionary) -> void:
		current_node = vn_node
		if !vn_node:
			push_error("next vn_node is NULL")
		else:
			current_id = vn_node.id

func _handle_next_node(vn_node: Dictionary) -> void:
	if !vn_node || vn_node == {}:
		push_error("unable to handle null next_node")
		return
		
	var vn_node_type_int = VnGraphNode.VnNodeType.keys().find(vn_node.node_type)
	match vn_node_type_int:
		
		VnGraphNode.VnNodeType.DIALOGUE:
			var dialogue_callback = func next_callback():
				_update_current_node(VNRunnerUtil.get_next_node(current_node))
				_handle_next_node(current_node)
			dialogue_reached.emit(vn_node.character, vn_node.dialogue, dialogue_callback)
			
		VnGraphNode.VnNodeType.DECISION:
			var decision_callback = func choice_callback(choice: int):
				_update_current_node(VNRunnerUtil.get_next_node(current_node, choice))
				_handle_next_node(current_node)
			decision_reached.emit(vn_node.decisions, decision_callback)
			
		VnGraphNode.VnNodeType.CONDITION:
			_update_current_node(VNRunnerUtil.determine_condition_next_node(current_node))
			_handle_next_node(current_node)
			
		VnGraphNode.VnNodeType.VARIABLE:
			VNRunnerUtil.apply_variable_node(current_node)
			_update_current_node(VNRunnerUtil.get_next_node(current_node))
			_handle_next_node(current_node)
			
		VnGraphNode.VnNodeType.INPUT:
			var input_callback = func answer_callback(input_text: String):
				_update_current_node(VNRunnerUtil.get_next_node(current_node))
				_handle_next_node(current_node)
			input_requested.emit(vn_node.user_input_q, input_callback)
			
		VnGraphNode.VnNodeType.SIGNAL:
			vn_trigger_signaled.emit(vn_node.signal_param)
			_update_current_node(VNRunnerUtil.get_next_node(current_node))
			_handle_next_node(current_node)
			
		VnGraphNode.VnNodeType.GOTO:
			_update_current_node(VNRunnerUtil.get_node_dict(vn_node.goto_node))
			_handle_next_node(current_node)
			
		VnGraphNode.VnNodeType.END:
			vn_ended.emit(vn_node.end_param)
			
		VnGraphNode.VnNodeType.START:
			_update_current_node(VNRunnerUtil.get_next_node(current_node))
			_handle_next_node(current_node)
		_:
			push_error("unkown node type [%s] for node [%s]" % [vn_node.node_type, vn_node.id])
