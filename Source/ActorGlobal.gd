extends Node

signal updated_actor_list()

var actorList:Array = ["Actor1", "Actor2"]
var colorList:Array = [Color("ffffff"), Color("ffd1d1")]

func get_text():
	var text: String = ""
	
	for i in range(actorList.size() - 1):
		text += actorList[i] + "|" + (colorList[i] as Color).to_html() + ","
	text += actorList[actorList.size() - 1] + "|" + (colorList[actorList.size() - 1] as Color).to_html()
	
	return text


func load_actors(actors: String) -> bool:
	DebugGlobal.message("Loading actors")
	if "#" in actors:
		actors = actors.replace("#", "")
		var tempActorList = actors.split(",", false)
		# If there are colors
		if "|" in actors:
			colorList.clear()
			actorList.clear()
			
			for actor in tempActorList:
				actor = actor.split("|", false)
				actorList.append(actor[0])
				colorList.append(actor[1])
		# If there are no colors
		else:
			actorList = tempActorList
			colorList.clear()
			for i in range(actorList.size()):
				colorList.append(Color("ffffff"))
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
	colorList.append(actorColor)
	DebugGlobal.message("Added actor")
	get_tree().call_group("actor_entry", "update_actor_list")
	emit_signal("updated_actor_list")
	return true


func update_actor(index: int, newName: String, newColor: Color, changeColor = false) -> bool:
	if actorList.find(newName) == -1 or changeColor:
		colorList[index] = newColor
		get_tree().call_group("_actor_" + actorList[index], "update_group", newName)
		
		actorList[index] = newName
		
		get_tree().call_group("actor_entry", "update_actor_list")
		emit_signal("updated_actor_list")
		return true
	return false
