extends WindowDialog

var saveDialog: FileDialog

onready var quitBtn = $MarginContainer/VBoxContainer/HBoxContainer/QuitBtn
onready var saveBtn = $MarginContainer/VBoxContainer/HBoxContainer/SaveBtn
onready var cancelBtn = $MarginContainer/VBoxContainer/HBoxContainer/CancelBtn

signal saveFile()

func _on_QuitBtn_pressed() -> void:
	get_tree().quit()

# TODO: Make the save button work
func _on_SaveBtn_pressed() -> void:
	pass


func _on_Cancel_pressed() -> void:
	hide()


func _on_QuitDialog_about_to_show() -> void:
	print("nani")
	yield(self,"visibility_changed")
	cancelBtn.grab_focus()


func _on_QuitDialog_focus_entered() -> void:
	print("nani2")
