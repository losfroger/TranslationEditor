extends "res://Source/entry_class.gd"


func loaded() -> void:
	subText.grab_focus()


func load_entry(text: String):
	subText.text = text.right(1)


func get_text():
	return "# " + subText.text
