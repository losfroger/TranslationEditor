extends HBoxContainer

onready var subText: LineEdit = $SubText

enum CHANGE_ACTOR {
	NEXT, PREVIOUS
}


# TODO: Make buttons to change the order of the subs
func loaded() -> void:
	subText.grab_focus()


func get_text() -> void:
	pass


func change_actor(change) -> void:
	pass


func _on_DeleteBtn_pressed() -> void:
	queue_free()
