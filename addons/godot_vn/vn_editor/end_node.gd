@tool
extends VnGraphNode

var end_param_edit : LineEdit

func _enter_tree():
	node_id_label = find_child("NodeId")
	if (node_id_label == null):
		push_error("missing decendent 'NodeId'")
	else:
		node_id_label.text = name
	end_param_edit = $EndParam

func import_data(data : Dictionary):
	name = data.id
	node_id_label.text = data.id
	position_offset = Vector2(data.position_offset[0], data.position_offset[1])
	position = Vector2(data.position[0], data.position[1])
	node_type = VnNodeType.get(data.node_type)
	end_param_edit.text = data.end_param

func export() -> Dictionary:
	return {
		"id": node_id_label.text,
		"position": [position.x, position.y],
		"position_offset": [position_offset.x, position_offset.y],
		"node_type": VnNodeType.keys()[node_type],
		"end_param" : end_param_edit.text,
		"connections" : []
	}
