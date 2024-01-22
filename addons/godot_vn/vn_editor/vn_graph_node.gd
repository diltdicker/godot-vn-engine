@tool
class_name VnGraphNode extends GraphNode

var node_id_label : LineEdit
@export var node_type : VnNodeType

enum VnNodeType {START, DIALOGUE, INPUT, CONDITION, 
VARIABLE, DECISION, SIGNAL, NOTES, END, GOTO}

func _enter_tree():
	node_id_label = find_child("NodeId")
	if (node_id_label == null):
		push_error("missing decendent 'NodeId'")
	else:
		node_id_label.text = name

func set_hex_id(id : String):
	if node_id_label != null:
		node_id_label.text = id
	name = id

func get_hex_id():
	return name
	
func export():
	return null

