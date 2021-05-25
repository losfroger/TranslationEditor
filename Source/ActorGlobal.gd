extends Node

var actorList:Array = ["Ina", "Kiara", "Nota"]

func get_text():
	var text: String = ""
	
	for i in range(actorList.size() - 1):
		text += actorList[i] + ","
	text += actorList[actorList.size() - 1]
	
	return text


func load_actors(actors: String):
	actors = actors.replace("#", "")
	actorList = actors.split(",", false)


# Returns if it was able to add the actor or not
func add_actor(actor: String, actorColor: Color) -> bool:
	if actorList.find(actor) >= 0:
		return false
	actorList.append(actor)
	get_tree().call_group("actor_entry", "update_actor_list")
	return true
