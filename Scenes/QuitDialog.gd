extends WindowDialog

var saveDialog: FileDialog
signal saveFile()

func _on_QuitBtn_pressed() -> void:
	get_tree().quit()

# TODO: Make the save button work
func _on_SaveBtn_pressed() -> void:
	pass


func _on_Cancel_pressed() -> void:
	hide()
