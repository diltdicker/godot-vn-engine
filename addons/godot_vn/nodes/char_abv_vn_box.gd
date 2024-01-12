@tool
extends TextureRect

@export_category("Visual Novel Controls")
@export_group("Controls")
@export var text_box_pos := Vector2(0,0)
@export var text_box_scale := Vector2(1,1)
@export var text_box_text := "Sample Text Here."
@export var back_button_visible := false
@export var menu_button_visible := false
@export var skip_button_visible := false

@export_group("Leftside Character")

## Left character img box posisiton reletive to the VN Box
@export var l_char_pos := Vector2(0,0)
## left character img box scale reletive to the VN Box
@export var l_char_scale := Vector2(1,1)
@export var l_char_img : CompressedTexture2D = preload("res://addons/godot_vn/sample_res/laugh.png")
@export var flip_l_char : bool = false

@export_group("Middleside Character")
@export var m_char_pos := Vector2(0,0)
@export var m_char_scale := Vector2(1,1)
@export var m_char_img : CompressedTexture2D = preload("res://addons/godot_vn/sample_res/sad.png")
@export var flip_m_char : bool = false

@export_group("Rightside Character")
@export var r_char_pos := Vector2(0,0)
@export var r_char_scale := Vector2(1,1)
@export var r_char_img : CompressedTexture2D = preload("res://addons/godot_vn/sample_res/smile.png")
@export var flip_r_char : bool = false

# Children

var _left_sprite
var _middle_sprite
var _right_sprite


var _text_box 


func _enter_tree():
	texture = preload("res://addons/godot_vn/sample_res/lines_blue.png")
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	_text_box = Label.new()
	_text_box.text = "text_box_text"
	add_child(_text_box, true)
	
	_left_sprite = TextureRect.new()
	_left_sprite.texture = l_char_img
	add_child(_left_sprite)
	
	_right_sprite = RichTextLabel.new()
	_right_sprite.text = "SAMPLE TEXT HERE"
	add_child(_right_sprite)
	
	pass

