extends HBoxContainer

onready var subText = $SubText
var index = 0

func loaded() -> void:
	subText.grab_focus()


func load_entry(text: String):
	subText.text = text.right(1)

func get_text():
	return "# " + subText.text

func _on_DeleteBtn_pressed() -> void:
	queue_free()
