extends HBoxContainer

signal delete()

onready var subText: LineEdit = $SubText
onready var deleteBtn: TextureButton = $DeleteBtn

enum CHANGE_ACTOR {
	NEXT, PREVIOUS
}


# TODO: Make buttons to change the order of the subs
# TODO: Add ability to change an actors color
func get_text() -> void:
	pass


func get_focus() -> void:
	subText.release_focus()
	yield(get_tree(), "idle_frame")
	subText.grab_focus()


func change_actor(change) -> void:
	pass


func _on_DeleteBtn_pressed() -> void:
	subText.grab_focus()
	emit_signal("delete")
