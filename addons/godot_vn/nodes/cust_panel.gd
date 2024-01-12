extends Panel

func test_method():
	print("foo:bar")

func _enter_tree():
	$CheckButton.connect("pressed", test_method())
