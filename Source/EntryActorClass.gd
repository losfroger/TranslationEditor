extends Entry
class_name EntryActor

onready var actorButton: OptionButton = $ActorButton


func _ready() -> void:
	actorButton.connect("item_selected", self, "select_changed")


func init() -> void:
	for actor in ActorGlobal.actorList:
		actorButton.add_item(actor)
	add_to_group("_actor_" + actorButton.get_item_text(0))


func select_changed(index: int) -> void:
	remove_from_group(get_groups()[-1])
	add_to_group("_actor_" + actorButton.get_item_text(index))
	update_color(index)


func update_color(index: int) -> void:
	var color: Color = ActorGlobal.colorList[index]
	actorButton.add_color_override("font_color", color)
	actorButton.add_color_override("font_color_hover", color)
	actorButton.add_color_override("font_color_pressed", color)


func update_group(newName: String):
	remove_from_group(get_groups()[-1])
	add_to_group("_actor_" + newName)
	update_color(actorButton.selected)


func change_actor(change) -> void:
	match change:
		CHANGE_ACTOR.NEXT:
			var id = (actorButton.selected + 1 
				if actorButton.selected + 1 < actorButton.get_item_count()
				else actorButton.selected)
			
			actorButton.select(id)
			select_changed(id)
		
		CHANGE_ACTOR.PREVIOUS:
			var id = (actorButton.selected - 1 
				if actorButton.selected - 1 >= 0
				else actorButton.selected)
			
			actorButton.select(id)
			select_changed(id)


func load_entry(actor: String, text: String) -> bool:
	subText.text = text.right(1)
	var id = ActorGlobal.actorList.find(actor)
	if id > -1:
		actorButton.select(id)
		select_changed(id)
		return true
	DebugGlobal.message("Actor not found while loading entry")
	return false


func get_text():
	return actorButton.get_item_text(actorButton.get_selected_id()) + ": " + subText.text


func update_actor_list():
	var auxSelect = actorButton.selected
	actorButton.clear()
	
	for actor in ActorGlobal.actorList:
		actorButton.add_item(actor)
	
	actorButton.selected = auxSelect
	select_changed(auxSelect)
