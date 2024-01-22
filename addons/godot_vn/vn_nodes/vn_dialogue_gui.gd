@tool
extends Control

var all_text_shown : bool = true
var word_list = []
var timer_busy : bool = true

var sylable_count = -1

var word_delay: float = 0.075
var sylable_delay : float = 0.05
var timer : Timer
var dialogue_margin: MarginContainer
var dialogue_edit: RichTextLabel
var dialogue_panel : Panel
var name_tag_margin: MarginContainer
var name_tag_edit : RichTextLabel
var name_tag_panel : Panel
var dialogue_callback : Callable
var full_text : String

func _enter_tree():
	dialogue_margin = $DialoguePanel/DialogueMarginContainer
	dialogue_edit = $DialoguePanel/DialogueMarginContainer/VnDialogueEdit
	dialogue_panel = $DialoguePanel
	name_tag_margin = $DialoguePanel/NametagPanel/NametagMarginContainer
	name_tag_panel = $DialoguePanel/NametagPanel
	name_tag_edit = $DialoguePanel/NametagPanel/NametagMarginContainer/NameTagEdit
	timer = $Timer


func _process(delta):
	if !Engine.is_editor_hint() && Input.is_action_just_released("ui_accept") && visible == true:
		_on_next_button_pressed()


func display_dialogue(char_name: String, dialogue_text: String, callback):
	dialogue_edit.text = ""
	dialogue_edit.bbcode_enabled = true
	name_tag_edit.text = "[center]%s[/center]" % char_name
	all_text_shown = false
	timer_busy = true
	word_list.clear()
	full_text = VNRunnerUtil.replace_vars_in_text(dialogue_text)
	word_list = full_text.split(" ")
	dialogue_callback = callback
	add_next_text()
	

func set_dialogue_styles(dialogue_color: Color, name_tag_color : Color, dialogue_top_margin : int,
name_tag_top_margin : int, dialogue_stylebox: StyleBox, name_tag_stylebox : StyleBox, dialogue_font_size : int,
name_tag_font_size: int):
	dialogue_margin.add_theme_constant_override("margin_top", dialogue_top_margin)
	dialogue_edit.add_theme_color_override("default_color", dialogue_color)
	dialogue_edit.add_theme_font_size_override("normal_font_size", dialogue_font_size)
	dialogue_edit.add_theme_font_size_override("bold_font_size", dialogue_font_size)
	dialogue_panel.add_theme_stylebox_override("panel", dialogue_stylebox)
	#
	name_tag_edit.add_theme_constant_override("margin_top", name_tag_top_margin)
	name_tag_edit.add_theme_color_override("default_color", name_tag_color)
	name_tag_edit.add_theme_font_size_override("normal_font_size", name_tag_font_size)
	name_tag_edit.add_theme_font_size_override("bold_font_size", name_tag_font_size)
	name_tag_panel.add_theme_stylebox_override("panel", name_tag_stylebox)


func add_next_text(skip: bool = false):
	if word_list.size() > 0:
		var word : String = word_list[0]
		word_list.remove_at(0)
		if word:
			dialogue_edit.text = dialogue_edit.text + word + " "
			if !skip:
				sylable_count = int(word.length() / 3)
				timer.wait_time = sylable_delay
				timer_busy = true
				timer.start()
	else:
		all_text_shown = true
		dialogue_edit.text = full_text
		

func _on_next_button_pressed():
	if all_text_shown:
		dialogue_callback.call()
	else:
		all_text_shown = true
		timer.stop()
		dialogue_edit.text = full_text


func _on_timer_timeout():
	if timer_busy:
		if sylable_count <= 0:
			timer_busy = false
			timer.wait_time = word_delay
			timer.start()
		else:
			sylable_count -= 1
			timer.start()
	else:
		add_next_text()
