extends Entry
class_name EntryActor

onready var actorButton: OptionButton = $ActorButton

func _ready() -> void:
	for actor in ActorGlobal.actorList:
		actorButton.add_item(actor)


func change_actor(change) -> void:
	match change:
		CHANGE_ACTOR.NEXT:
			actorButton.select(
				actorButton.selected + 1 
				if actorButton.selected + 1 < actorButton.get_item_count()
				else actorButton.selected
				)
		
		CHANGE_ACTOR.PREVIOUS:
			actorButton.select(
				actorButton.selected - 1 
				if actorButton.selected - 1 >= 0
				else actorButton.selected
				)


func load_entry(actor: String, text: String) -> bool:
	subText.text = text.right(1)
	var id = ActorGlobal.actorList.find(actor)
	if id > -1:
		actorButton.select(ActorGlobal.actorList.find(actor))
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
