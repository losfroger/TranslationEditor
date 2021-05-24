extends WindowDialog

var saveDialog: FileDialog

onready var cancelBtn = $MarginContainer/VBoxContainer/HBoxContainer/CancelBtn

signal saveFile()

func _on_QuitBtn_pressed() -> void:
	get_tree().quit()


# TODO: Make the save button work
func _on_SaveBtn_pressed() -> void:
	pass


func _on_Cancel_pressed() -> void:
	hide()

func show() -> void:
	popup_centered()
	cancelBtn.grab_focus()
