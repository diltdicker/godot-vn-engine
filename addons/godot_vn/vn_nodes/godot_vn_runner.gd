@tool

## Ready-to-go UI Node with built-in backend for running a Visual Novel Graph.
## Create a *.gdvn.tres file using the GodotVN editor
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
## Name tag theme
@export var name_tag_theme : StyleBox = preload("res://addons/godot_vn/themes/gdvn_name_tag.stylebox")
## Font Size for GUI
@export var name_tag_font_size : int = 44
## Name tag font color
@export var name_tag_font_color : Color = Color.BLACK
## Name tag top margin
@export var name_tag_top_margin : int = 3
## Visual Novel Stylebox
@export var vn_theme : StyleBox = preload("res://addons/godot_vn/themes/gdvn_visual_novel.stylebox")
## Font Size for GUI
@export var vn_font_size : int = 44
## Visual Novel font color
@export var vn_font_color : Color = Color.WHITE
## Name tag top margin
@export var vn_top_margin : int = 30

# editor only vars
## Implemented in inpspector plugin for displaying DialogueGui preview in Editor
@export var make_dialogue_visible : bool = false
## Implemented in inpspector plugin for displaying DecisionGui preview in Editor
@export var make_decision_visible : bool = false
## Implemented in inpspector plugin for displaying InputGui preview in Editor
@export var make_input_visible : bool = false
## Used in DialogueGui for text reveal speed
@export var text_reveal_word_delay : float = 0.075
## Used in DialogueGui for text reveal speed
@export var text_reveal_sylable_delay : float = 0.05

# refs to internal nodes
var _headless_runner : HeadlessVnRunner
var dialogue_gui
var input_gui : VnInputGui
var decision_gui : VnDecisionGui
var _timer : Timer

## Triggers runner to start progressing through VN grpah.
## Searchs VN graph start nodes for node with matching param.
## Upon starting, runner will begin emitting signals: [vn_trigger_signaled, dialogue_reached,
## vn_ended, decision_reached, input_requested] as it progresses through VN graph.
func vn_start(param: String):
	dialogue_gui.word_delay = text_reveal_word_delay
	dialogue_gui.sylable_delay = text_reveal_sylable_delay
	apply_style_changes()
	_headless_runner.vn_start(default_start_param)


## Triggers runner to start progressing through VN grpah. 
## Imediately skips to provided node_id and begins there. (useful if loading a saved game).
## Upon starting, runner will begin emitting signals: [vn_trigger_signaled, dialogue_reached,
## vn_ended, decision_reached, input_requested] as it progresses through VN graph.
func vn_skip(node_id: String):
	dialogue_gui.word_delay = text_reveal_word_delay
	dialogue_gui.sylable_delay = text_reveal_sylable_delay
	apply_style_changes()
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

func gui_hide_all():
	dialogue_gui.visible = false
	decision_gui.visible = false
	input_gui.visible = false

func gui_show_dialogue():
	dialogue_gui.visible = true
	decision_gui.visible = false
	input_gui.visible = false

func gui_show_decision():
	dialogue_gui.visible = false
	decision_gui.visible = true
	input_gui.visible = false

func gui_show_input():
	dialogue_gui.visible = false
	decision_gui.visible = false
	input_gui.visible = true

## Method to apply themes set in the inspector for fonts and styleboxes of DialogueGui (used by inspector plugin)
func apply_style_changes():
	dialogue_gui.set_dialogue_styles(vn_font_color, name_tag_font_color, vn_top_margin, name_tag_top_margin,
	vn_theme, name_tag_theme, vn_font_size, name_tag_font_size)


func _ready():
	if Engine.is_editor_hint():
		#_headless_runner = HeadlessVnRunner.new()
		#add_child(_headless_runner)
		#_headless_runner.connect("decision_reached", _on_headless_vn_runner_decision_reached)
		#_headless_runner.connect("dialogue_reached", _on_headless_vn_runner_dialogue_reached)
		#_headless_runner.connect("input_requested", _on_headless_vn_runner_input_requested)
		#_headless_runner.connect("vn_ended", _on_headless_vn_runner_vn_ended)
		#_headless_runner.connect("vn_trigger_signaled", _on_headless_vn_runner_vn_trigger_signaled)
		#dialogue_gui = preload("res://addons/godot_vn/vn_nodes/VnDialogueGui.tscn").instantiate()
		#add_child(dialogue_gui)
		#apply_style_changes()
		#decision_gui = preload("res://addons/godot_vn/vn_nodes/VnDecisionGui.tscn").instantiate()
		#add_child(decision_gui)
		#input_gui = preload("res://addons/godot_vn/vn_nodes/VnInputGui.tscn").instantiate()
		#add_child(input_gui)
		#theme = preload("res://addons/godot_vn/themes/gdvn.theme")
		#gui_hide_all()
		pass
	if !Engine.is_editor_hint():
		_headless_runner.ignore_visited_signals = ignore_visited_signals
		_headless_runner.ignore_visited_variables = ignore_visited_variables
		if start_on_ready:
			_headless_runner.godot_vn_file = godot_vn_file
			vn_start(default_start_param)
		

func _enter_tree():
	# setup headless runner
	_headless_runner = HeadlessVnRunner.new()
	add_child(_headless_runner)
	_headless_runner.connect("decision_reached", _on_headless_vn_runner_decision_reached)
	_headless_runner.connect("dialogue_reached", _on_headless_vn_runner_dialogue_reached)
	_headless_runner.connect("input_requested", _on_headless_vn_runner_input_requested)
	_headless_runner.connect("vn_ended", _on_headless_vn_runner_vn_ended)
	_headless_runner.connect("vn_trigger_signaled", _on_headless_vn_runner_vn_trigger_signaled)
	dialogue_gui = preload("res://addons/godot_vn/vn_nodes/VnDialogueGui.tscn").instantiate()
	add_child(dialogue_gui)
	apply_style_changes()
	decision_gui = preload("res://addons/godot_vn/vn_nodes/VnDecisionGui.tscn").instantiate()
	add_child(decision_gui)
	input_gui = preload("res://addons/godot_vn/vn_nodes/VnInputGui.tscn").instantiate()
	add_child(input_gui)
	theme = preload("res://addons/godot_vn/themes/gdvn.theme")
	gui_hide_all()
	if Engine.is_editor_hint():
		pass


func _on_headless_vn_runner_vn_ended(param):
	gui_hide_all()
	vn_ended.emit(param)


func _on_headless_vn_runner_vn_trigger_signaled(param):
	vn_trigger_signaled.emit(param)


func _on_headless_vn_runner_input_requested(question_text, answer_callback):
	gui_show_input()
	input_gui.display_input_question(question_text, answer_callback)


func _on_headless_vn_runner_dialogue_reached(char_name, dialogue_text, next_callback):
	gui_show_dialogue()
	dialogue_gui.display_dialogue(char_name, dialogue_text, next_callback)


func _on_headless_vn_runner_decision_reached(choices, decision_callback):
	gui_show_decision()
	decision_gui.display_decision(choices, decision_callback)
