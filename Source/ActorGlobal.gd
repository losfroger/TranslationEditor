extends Node

var actorList:Array = ["Ina", "Kiara", "Nota"]

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
	return true
