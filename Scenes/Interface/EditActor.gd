extends WindowDialog


onready var actorSelector = $Margin/VBoxContainer/ActorSelector
onready var nameText = $Margin/VBoxContainer/InfoPanel/Margin/Options/NameContainer/Name

onready var numActorLabel = $Margin/VBoxContainer/InfoPanel/Margin/Options/Instances/NumActor
onready var deleteBtn = $Margin/VBoxContainer/InfoPanel/Margin/Options/Instances/Delete

onready var warning = $Margin/VBoxContainer/InfoPanel/Margin/Options/Warning

func _ready() -> void:
	update_actor_list()
	ActorGlobal.connect("updated_actor_list", self, "update_actor_list")


func update_actor_list():
	actorSelector.clear()
	for actor in ActorGlobal.actorList:
			actorSelector.add_item(actor)


func _on_ActorSelector_item_selected(index: int) -> void:
	if index > -1:
		warning.visible = false
		var count = get_tree().get_nodes_in_group("_actor_" + actorSelector.get_item_text(index)).size()
		nameText.text = actorSelector.get_item_text(index)
		numActorLabel.text = "Number of instances: " + String(count)
		if count > 0:
			deleteBtn.disabled = true
		else:
			deleteBtn.disabled = false


func _on_EditActor_about_to_show() -> void:
	warning.visible = false
	_on_ActorSelector_item_selected(actorSelector.selected)


func _on_Accept_pressed() -> void:
	if nameText.text != actorSelector.get_item_text(actorSelector.selected):
		if not ActorGlobal.update_actor(actorSelector.selected, nameText.text):
			warning.visible = true
		else:
			warning.visible = false
			hide()


func _on_Accept3_pressed() -> void:
	warning.visible = false
	hide()
