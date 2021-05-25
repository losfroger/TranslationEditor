extends WindowDialog

onready var nameText = $MarginContainer/VBoxContainer/NameContainer/Name
onready var colorPicker = $MarginContainer/VBoxContainer/ColorContainer/Color
onready var warningText = $MarginContainer/VBoxContainer/Warning

func _on_Cancel_pressed() -> void:
	hide()
	nameText.clear()


func _on_Accept_pressed() -> void:
	if (not nameText.text.empty()
		and ActorGlobal.add_actor(nameText.text, colorPicker.color)):
		warningText.visible = false
		hide()
		nameText.clear()
	else:
		warningText.visible = true


func _on_AddActor_about_to_show() -> void:
	nameText.clear()
	warningText.visible = false
