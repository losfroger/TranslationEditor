extends Node

var actorList:Array = ["Ina", "Kiara", "Comentario"]

func get_text():
	var text: String = ""
	
	for i in range(actorList.size() - 1):
		text += actorList[i] + ","
	text += actorList[actorList.size() - 1]
	
	return text


func load_actors(actors: String):
	actors = actors.replace("#", "")
	actorList = actors.split(",", false)
