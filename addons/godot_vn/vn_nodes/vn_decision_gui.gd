@tool
class_name VnDecisionGui extends CenterContainer

const bttn_scrpt = preload("res://addons/godot_vn/vn_nodes/vn_decision_gui_button.gd")

var decision_callback : Callable
var vbox_container : VBoxContainer
var choice_list : Array = []


func _enter_tree():
	vbox_container = $DecisonPanel/MarginContainer/VBoxContainer

func _ready():
	pass

func display_decision(choices: Array, callback):
	
	for option in vbox_container.get_children():
		option.queue_free()
	decision_callback = callback
	choice_list.clear()
	choice_list = choices.duplicate(true)
	for option in choices:
		var choice_box = Button.new()
		choice_box.set_script(bttn_scrpt)
		vbox_container.add_child(choice_box)
		choice_box.text = option
		choice_box.connect("pressed", choice_box.on_button_pressed)
		choice_box.connect("choice_made", choice_made)
		

func choice_made(choice: String):
	decision_callback.call(choice_list.find(choice))
