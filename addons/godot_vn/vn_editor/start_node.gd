@tool
extends GraphNode

@export var node_id_label : LineEdit

func _enter_tree():
	
	var datetime_str = Time.get_datetime_string_from_system()
	var regex = RegEx.new()
	regex.compile("(\\d+)")
	var deci_str = ""
	for result in regex.search_all(datetime_str):
		deci_str += result.get_string()
	node_id_label.text = "%x" % int(deci_str + str(Time.get_ticks_msec() % 999))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
