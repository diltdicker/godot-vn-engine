@tool
extends GraphEdit

func _enter_tree():
	#set_custom_minimum_size(Vector2(500,500))
	#print(size)
	#print(get_parent_area_size())
	set_custom_minimum_size(get_parent_area_size())
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

