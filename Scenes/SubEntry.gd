extends HBoxContainer

onready var actorButton = $ActorButton
onready var subText = $SubText
var index = 0

# TODO: Make buttons to change the order of the subs

func _ready() -> void:
	subText.grab_focus()
	
	for actor in ActorGlobal.actorList:
		actorButton.add_item(actor)


func load_entry(actor: String, text: String):
	print("-" + text.right(1) + "-")
	subText.text = text.right(1)
	print(ActorGlobal.actorList)
	print(ActorGlobal.actorList.find(actor))
	actorButton.select(ActorGlobal.actorList.find(actor))

func get_text():
	return actorButton.get_item_text(actorButton.get_selected_id()) + ": " + subText.text


func _on_DeleteBtn_pressed() -> void:
	queue_free()
