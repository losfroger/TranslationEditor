extends Entry

func _ready() -> void:
	subText = $SubText

func load_entry(text: String):
	subText.text = text.right(1)


func get_text():
	return "# " + subText.text
