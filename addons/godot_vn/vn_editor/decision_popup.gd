@tool
extends Popup

signal decision_made(port: int)

const decision_choice_pckd = preload("res://addons/godot_vn/vn_editor/DecsionPopUpSubNode.tscn")
@export var container : VBoxContainer


## apply current node data to UI
func apply_data(data):
	var port_num = 0
	for decision in data.decisions:
		var decision_node = decision_choice_pckd.instantiate()
		
		container.add_child(decision_node)
		decision_node.connect("button_pressed", handle_decision)
		decision_node.set_decision(decision, port_num)
		port_num += 1
	

func handle_decision(port: int):
	for child in container.get_children():
		child.queue_free()
	size.y = 41
	hide()
	decision_made.emit(port)
