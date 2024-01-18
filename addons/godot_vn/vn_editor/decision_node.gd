@tool
extends VnGraphNode

const pckd_sub_node = preload("res://addons/godot_vn/vn_editor/DecisionSubNode.tscn")
var decision_list : Array[Dictionary] = []
var new_decision : LineEdit
var add_timer : Timer
var decsion_notes : TextEdit

signal delete_decision_port


func _enter_tree():
	node_id_label = find_child("NodeId")
	if (node_id_label == null):
		push_error("missing decendent 'NodeId'")
	else:
		node_id_label.text = name
	add_timer = $NodeIdContainer/AddTimer
	decsion_notes = $DecisionNotes
	
	create_new_decision_edit()


func handle_decision_delete(decision_id: int):
	delete_decision_port.emit(get_hex_id(), decision_id)
	decision_list[decision_id].node.queue_free()
	var del_slot: int = decision_list[decision_id].slot
	decision_list.remove_at(decision_id)
	set_slot_enabled_right(del_slot, false)
	
	# move active slots down in graphnode
	for i in range(decision_list.size()):
		decision_list[i].node.set_id(i)
		if decision_list[i].slot > del_slot:
			set_slot_enabled_right(decision_list[i].slot, false)
			decision_list[i].slot -= 1
			set_slot_enabled_right(decision_list[i].slot, true)
	


func spawn_decision():
	new_decision.disconnect("text_changed", reset_timer)
	remove_child(new_decision)
	var decision = pckd_sub_node.instantiate()
	
	self.add_child(decision, true)
	
	decision.set_id(decision_list.size())
	decision.connect("request_decision_delete", handle_decision_delete)
	decision.replace_decision_text(new_decision)
	var decision_index = decision.get_index()
	
	decision_list.append({
		"node": decision,
		"slot": decision_index
	})
	create_new_decision_edit()
	set_slot_enabled_right(decision_index, true)


func create_new_decision_edit():
	new_decision = LineEdit.new()
	new_decision.connect("text_changed", reset_timer)
	new_decision.placeholder_text = "text here..."
	add_child(new_decision, true)
	

func import_data(data : Dictionary):
	name = data.id
	node_id_label.text = data.id
	position_offset = Vector2(data.position_offset[0], data.position_offset[1])
	position = Vector2(data.position[0], data.position[1])
	node_type = VnNodeType.get(data.node_type)
	decsion_notes.text = data.notes
	for decision in data.decisions:
		new_decision.text = decision
		spawn_decision()

func export() -> Dictionary:
	var decisions = []
	for decision in decision_list:
		decisions.append(decision.node.get_text())
	return {
		"id": node_id_label.text,
		"position": [position.x, position.y],
		"position_offset": [position_offset.x, position_offset.y],
		"node_type": VnNodeType.keys()[node_type],
		"notes": decsion_notes.text,
		"decisions" : decisions,
		"connections" : []
	}


func reset_timer(text_changed):
	add_timer.start()


func _on_add_timer_timeout():
	spawn_decision()
