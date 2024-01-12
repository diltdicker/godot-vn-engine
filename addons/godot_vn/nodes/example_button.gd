@tool
extends Button

func clicked():
	print('you clicked me')

func _enter_tree():
	pressed.connect(clicked)
