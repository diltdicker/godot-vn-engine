class_name GodotVnRunner extends Control


## Signal emitted from signal node in VN graph
signal vn_trigger_signaled(param: String)

## VN graph reached an end node (useful for when to switch from VN mode to gameplay)
signal vn_ended(param: String)


## Visual novel graph file containing dilogue, events, variables etc... (create using GodotVN editor)
@export var godot_vn_file : VnGraphResource
## Start param for which start node to enter VN graph (not needed if only 1 start node)
@export var default_start_param : String = ""
## Begins emitting signals from VN upon _ready()
@export var start_on_ready: bool = false
## If a variable node has already been visited, ingore it and skip to next node.
## (useful if implementing a back feature)
@export var ignore_visited_variables : bool = false
## If a signal node has already been visited, ingore it and skip to next node.
## (useful if implementing a back feature)
@export var ignore_visited_signals : bool = false

# refs to internal nodes
var _headless_runner : HeadlessVNRunner

## Triggers runner to start progressing through VN grpah.
## Searchs VN graph start nodes for node with matching param.
## Upon starting, runner will begin emitting signals: [vn_trigger_signaled, dialogue_reached,
## vn_ended, decision_reached, input_requested] as it progresses through VN graph.
func vn_start(param: String):
	_headless_runner.vn_start(default_start_param)


## Triggers runner to start progressing through VN grpah. 
## Imediately skips to provided node_id and begins there. (useful if loading a saved game).
## Upon starting, runner will begin emitting signals: [vn_trigger_signaled, dialogue_reached,
## vn_ended, decision_reached, input_requested] as it progresses through VN graph.
func vn_skip(node_id: String):
	_headless_runner.vn_skip(node_id)


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

## returns the hexid of current node in VN graph (useful for if you want to save game in the middle of graph)
func get_current_node_id() -> String:
	return _headless_runner.current_id
## returns list of ids of previously seen dialogues (useful for if you want to implement skip functionality to your game)
func get_seen_dialogues() -> Array[String]:
	return _headless_runner.seen_dialogues


func _ready():
	_headless_runner.ignore_visited_signals = ignore_visited_signals
	_headless_runner.ignore_visited_variables = ignore_visited_variables
	if start_on_ready:
		vn_start(default_start_param)
		
func _enter_tree():
	_headless_runner = $HeadlessVnRunner


func _on_headless_vn_runner_vn_ended(param):
	vn_ended.emit(param)


func _on_headless_vn_runner_vn_trigger_signaled(param):
	vn_trigger_signaled.emit(param)


func _on_headless_vn_runner_input_requested(question_text, answer_callback):
	pass # Replace with function body.


func _on_headless_vn_runner_dialogue_reached(char_name, dialogue_text, next_callback):
	pass # Replace with function body.


func _on_headless_vn_runner_decision_reached(choices, decision_callback):
	pass # Replace with function body.
