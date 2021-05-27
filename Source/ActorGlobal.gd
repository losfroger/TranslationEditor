extends Node

signal updated_actor_list()

var actorList:Array = ["Actor"]

func get_text():
	var text: String = ""
	
	for i in range(actorList.size() - 1):
		text += actorList[i] + ","
	text += actorList[actorList.size() - 1]
	
	return text


func load_actors(actors: String) -> bool:
	DebugGlobal.message("Loading actors")
	if "#" in actors:
		actors = actors.replace("#", "")
		actorList = actors.split(",", false)
		emit_signal("updated_actor_list")
		return true
	DebugGlobal.message("Error: Actors not found")
	return false


# Returns if it was able to add the actor or not
func add_actor(actor: String, actorColor: Color) -> bool:
	DebugGlobal.message("Adding actor: " + actor)
	if actorList.find(actor) >= 0:
		DebugGlobal.message("Actor already in the list")
		return false
	actorList.append(actor)
	DebugGlobal.message("Added actor")
	get_tree().call_group("actor_entry", "update_actor_list")
	emit_signal("updated_actor_list")
	return true


func update_actor(index: int, newName: String) -> bool:
	if actorList.find(newName) == -1:
		get_tree().call_group("_actor_" + actorList[index], "update_group", newName)
		
		actorList[index] = newName
		
		get_tree().call_group("actor_entry", "update_actor_list")
		emit_signal("updated_actor_list")
		return true
	return false
