@tool
extends HBoxContainer

@export var button: Button
var port_value: int = -1

signal button_pressed(port: int)

func set_decision(text: String, port_num: int):
	port_value = port_num
	button.text = text

func _on_button_pressed():
	button_pressed.emit(port_value)
